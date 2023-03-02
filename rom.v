module rom # (
  parameter INSTRS_WIDTH = 32,
  parameter ADDR_WIDTH = 8,
  parameter ROM_SIZE = 64
) (
  input    [ADDR_WIDTH-1:0] pc,
  output [INSTRS_WIDTH-1:0] instr
);

reg [INSTRS_WIDTH-1:0] mem [0:ROM_SIZE-1];

assign instr = mem[pc];

localparam op_halt    = 8'h00;
localparam op_wait    = 8'h01;
localparam op_fill    = 8'h02;
localparam op_release = 8'h03;
localparam op_forward = 8'h04;
localparam op_reverse = 8'h05;
localparam op_set     = 8'h11;
localparam op_dec     = 8'h12;
localparam op_jz      = 8'h21;
localparam op_jnz     = 8'h22;

integer i;
initial begin
  for (i = 0; i < 64; i++)
    mem[i] = 32'h0000;

  mem[02] = {16'd100, 8'd00, op_fill};
  mem[03] = {16'd050, 8'd00, op_wait};
  mem[04] = {16'd005, 8'd00, op_set};
  // loop start
  mem[05] = {16'd020, 8'd00, op_forward};
  mem[06] = {16'd010, 8'd00, op_wait};
  mem[07] = {16'd020, 8'd00, op_reverse};
  mem[08] = {16'd010, 8'd00, op_wait};
  mem[09] = {16'd000, 8'd00, op_dec};
  mem[10] = {16'd005, 8'd00, op_jnz};
  // loop end
  mem[11] = {16'd100, 8'd00, op_release};
end

endmodule