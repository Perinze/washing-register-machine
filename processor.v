module processor (
  input         ena,
  input  [15:0] instr,
  output  [7:0] pc,

  output ctrl_fill,
  output ctrl_release,
  output ctrl_forward,
  output ctrl_reverse,

  input clk,
  input rst_n
);

localparam op_wait    = 8'h01;
localparam op_fill    = 8'h02;
localparam op_release = 8'h03;
localparam op_forward = 8'h04;
localparam op_reverse = 8'h05;
localparam op_set     = 8'h11;
localparam op_dec     = 8'h12;
localparam op_jz      = 8'h21;
localparam op_jnz     = 8'h22;

wire op_is_wait;
wire op_is_fill;
wire op_is_release;
wire op_is_forward;
wire op_is_reverse;
wire op_is_set;
wire op_is_dec;
wire op_is_jz;
wire op_is_jnz;

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
wire [7:0] arg;

assign opcode = instr[7:0];
assign arg = instr[15:8];

wire sleep;
wire sleep_next;
wire sleep_instr;
wire sleep_exit_ena;
wire active_exit_ena;
wire keep_state;

assign sleep_instr =
  opcode[7:4] == 4'd0;
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

wire [7:0] var;
wire [7:0] var_next;

assign ctrl_fill    = ~irq & op_is_fill;
assign ctrl_release = ~irq & op_is_release;
assign ctrl_forward = ~irq & op_is_forward;
assign ctrl_reverse = ~irq & op_is_reverse;

assign var_keep = ~op_is_set & ~op_is_dec;
assign var_next =
    ({8{op_is_set}} & arg)
  | ({8{op_is_dec}} & (var - 8'd1))
  | ({8{var_keep }} & var);

dffr #(8) var_dff (
  .dnxt(var_next),
  .qout(var),
  .clk(clk),
  .rst_n(rst_n)
);

wire [7:0] pc;
wire [7:0] pc_next;

wire fetch;
wire jump;
wire stay;

assign jump =
    (op_is_jz  & (var == 8'd0))
  | (op_is_jnz & (var != 8'd0));
assign fetch =
    ( sleep_instr & irq)
  | (~sleep_instr & ~jump);
assign stay =
  ~jump & ~fetch;

assign pc_next =
    ({9{jump }} & arg)
  | ({9{fetch}} & pc + 8'd1)
  | ({9{stay }} & pc);

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