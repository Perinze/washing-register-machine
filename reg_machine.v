module reg_machine (
  input start,

  output ctrl_fill,
  output ctrl_release,
  output ctrl_forward,
  output ctrl_reverse,

  input clk,
  input rst_n
);

wire [7:0] pc;
wire [15:0] instr;

rom rom0 (
  .pc(pc),
  .instr(instr)
);

processor processor0 (
  .ena(1'b1),
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