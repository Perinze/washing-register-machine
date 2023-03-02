module rom # (
  parameter INSTRS_WIDTH = 32,
  parameter ADDR_WIDTH = 8,
  parameter ROM_SIZE = 32
) (
  input    [ADDR_WIDTH-1:0] pc,
  output [INSTRS_WIDTH-1:0] instr
);

reg [INSTRS_WIDTH-1:0] mem [0:ROM_SIZE-1];

assign instr = mem[pc];

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

integer i;
initial begin
  for (i = 0; i < 64; i++)
    mem[i] = 32'h0000;

  // clean start
  mem[02] = {16'd0001, 8'd02, op_set};
  mem[03] = {16'd0100, 8'd00, op_fill};
  mem[04] = {16'd0050, 8'd00, op_wait};
  mem[05] = {16'd0005, 8'd00, op_set};
  // loop 0 start
  mem[06] = {16'd0020, 8'd00, op_forward};
  mem[07] = {16'd0010, 8'd00, op_wait};
  mem[08] = {16'd0020, 8'd00, op_reverse};
  mem[09] = {16'd0010, 8'd00, op_wait};
  mem[10] = {16'd0000, 8'd00, op_dec};
  mem[11] = {16'd0006, 8'd00, op_jnz};
  // loop 0 end
  mem[12] = {16'd0100, 8'd00, op_release};
  // clean end

  // rinse start
  mem[13] = {16'd0002, 8'd02, op_set};
  mem[14] = {16'd0003, 8'd00, op_set};
  // loop 0 start
  mem[15] = {16'd0100, 8'd00, op_fill};
  mem[16] = {16'd0005, 8'd01, op_set};
  // loop 1 start
  mem[17] = {16'd0020, 8'd00, op_forward};
  mem[18] = {16'd0010, 8'd00, op_wait};
  mem[19] = {16'd0020, 8'd00, op_reverse};
  mem[20] = {16'd0010, 8'd00, op_wait};
  mem[21] = {16'd0000, 8'd01, op_dec};
  mem[22] = {16'd0017, 8'd01, op_jnz};
  // loop 1 end
  mem[23] = {16'd0100, 8'd00, op_release};
  mem[24] = {16'd0000, 8'd00, op_dec};
  mem[25] = {16'd0015, 8'd00, op_jnz};
  // loop 0 end
  // rinse end

  // dry start
  mem[26] = {16'd0003, 8'd02, op_set};
  mem[27] = {16'd0200, 8'd00, op_forward};
  // dry end
  // back to addr 0
  mem[28] = {16'd0004, 8'd02, op_set};
end

endmodule