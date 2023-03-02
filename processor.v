module processor # (
  parameter OPCODE_WIDTH = 8,
  parameter REG_WIDTH = 8,
  parameter IMME_WIDTH = 16,
  parameter INSTRS_WIDTH = 32,
  parameter ADDR_WIDTH = 8,
  parameter REG_NUM = 2
) (
  input                     ena,
  input  [INSTRS_WIDTH-1:0] instr,
  output   [ADDR_WIDTH-1:0] pc,

  output ctrl_fill,
  output ctrl_release,
  output ctrl_forward,
  output ctrl_reverse,

  input clk,
  input rst_n
);

localparam op_halt    = 8'h00;
localparam op_wait    = 8'h11;
localparam op_fill    = 8'h12;
localparam op_release = 8'h13;
localparam op_forward = 8'h14;
localparam op_reverse = 8'h15;
localparam op_set     = 8'h21;
localparam op_dec     = 8'h22;
localparam op_j       = 8'h30;
localparam op_jz      = 8'h31;
localparam op_jnz     = 8'h32;

wire op_is_halt;
wire op_is_wait;
wire op_is_fill;
wire op_is_release;
wire op_is_forward;
wire op_is_reverse;
wire op_is_set;
wire op_is_dec;
wire op_is_jz;
wire op_is_jnz;

assign op_is_halt    = opcode == op_halt;
assign op_is_wait    = opcode == op_wait;
assign op_is_fill    = opcode == op_fill;
assign op_is_release = opcode == op_release;
assign op_is_forward = opcode == op_forward;
assign op_is_reverse = opcode == op_reverse;
assign op_is_set     = opcode == op_set;
assign op_is_dec     = opcode == op_dec;
assign op_is_jz      = opcode == op_jz;
assign op_is_jnz     = opcode == op_jnz;


wire [7:0] opcode;
wire [7:0] reg_id;
wire [15:0] arg;

assign opcode = instr[7:0];
assign reg_id = instr[15:8];
assign arg = instr[31:16];

wire sleep;
wire sleep_next;
wire sleep_instr;
wire sleep_exit_ena;
wire active_exit_ena;
wire keep_state;

assign sleep_instr =
  opcode[7:4] == 4'd1;
assign active_exit_ena =
  (~sleep) & sleep_instr;
assign sleep_exit_ena =
  sleep & irq;
assign keep_state =
  ~active_exit_ena & ~sleep_exit_ena;

assign sleep_next =
    (active_exit_ena & 1'b1)
  | (sleep_exit_ena  & 1'b0)
  | (keep_state      & sleep);

dffr #(1) sleep_dff (
  .dnxt(sleep_next),
  .qout(sleep),
  .clk(clk),
  .rst_n(rst_n)
);

assign ctrl_fill    = ~irq & op_is_fill;
assign ctrl_release = ~irq & op_is_release;
assign ctrl_forward = ~irq & op_is_forward;
assign ctrl_reverse = ~irq & op_is_reverse;

wire [15:0] var [0:REG_NUM-1];
wire [15:0] var_next [0:REG_NUM-1];
wire var_set [0:REG_NUM-1];
wire var_dec [0:REG_NUM-1];
wire var_keep [0:REG_NUM-1];

genvar i;
generate
  for (i = 0; i < REG_NUM; i = i + 1) begin : var_loop
    assign var_set[i] = (reg_id == i) & op_is_set;
    assign var_dec[i] = (reg_id == i) & op_is_dec;
    assign var_keep[i] = ~var_set[i] & ~var_dec[i];
    assign var_next[i] =
        ({16{ var_set[i]}} & arg)
      | ({16{ var_dec[i]}} & (var[i] - 16'd1))
      | ({16{var_keep[i]}} & var[i]);
    dffr #(16) var_dff (
      .dnxt(var_next[i]),
      .qout(var[i]),
      .clk(clk),
      .rst_n(rst_n)
    );
  end
endgenerate

wire [7:0] pc;
wire [7:0] pc_next;

wire fetch;
wire jump;
wire stay;

assign jump =
    (op_is_jz  & (var[reg_id] == 16'd0))
  | (op_is_jnz & (var[reg_id] != 16'd0));
assign fetch =
    ( sleep_instr & irq)
  | (~sleep_instr & ~jump & ~op_is_halt);
assign stay =
  ~jump & ~fetch;

assign pc_next =
    ({8{jump }} & arg)
  | ({8{fetch}} & pc + 8'd1)
  | ({8{stay }} & pc);

dffr #(8) pc_dff (
  .dnxt(pc_next),
  .qout(pc),
  .clk(clk),
  .rst_n(rst_n)
);

wire load;
wire irq;
assign load = sleep_instr & ~sleep;
timer timer0 (
  .set(arg),
  .load(load),
  .irq(irq),
  .clk(clk),
  .rst_n(rst_n)
);

endmodule