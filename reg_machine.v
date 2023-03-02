module reg_machine # (
  parameter INSTRS_WIDTH = 32,
  parameter ADDR_WIDTH = 8
) (
  input start,

  output ctrl_fill,
  output ctrl_release,
  output ctrl_forward,
  output ctrl_reverse,

  input clk,
  input rst_n
);

wire [ADDR_WIDTH-1:0] pc;
wire [INSTRS_WIDTH-1:0] instr;

rom rom0 (
  .pc(pc),
  .instr(instr)
);

processor processor0 (
  .ena(1'b1),
  .start(start),
  .instr(instr),
  .pc(pc),
  .ctrl_fill(ctrl_fill),
  .ctrl_release(ctrl_release),
  .ctrl_forward(ctrl_forward),
  .ctrl_reverse(ctrl_reverse),
  .clk(clk),
  .rst_n(rst_n)
);

endmodule