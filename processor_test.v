`timescale 1ms/1ns
module processor_test;

reg clk;
reg rst_n;

initial begin
    $dumpfile("processor_test.vcd");
    $dumpvars(0, processor_test);
end

always #(0.5)
  clk = ~clk;

initial begin
  clk <= 1'b0;
  rst_n <= 1'b0;
  #(2) rst_n <= 1'b1;
end

localparam op_wait    = 8'h01;
localparam op_fill    = 8'h02;
localparam op_release = 8'h03;
localparam op_forward = 8'h04;
localparam op_reverse = 8'h05;
localparam op_set     = 8'h11;
localparam op_dec     = 8'h12;
localparam op_jz      = 8'h21;

reg [15:0] instr = 16'd0;
wire [7:0] pc;
wire ctrl_fill;
wire ctrl_release;
wire ctrl_forward;
wire ctrl_reverse;

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

initial begin
  #(2)
  instr = {8'h20, op_fill};
  #(33)
  instr = {8'h30, op_release};
  #(49)
  instr = {8'h40, op_forward};
  #(65)
  instr = {8'h50, op_reverse};
  #(81)
  instr = {8'h60, op_wait};
  #(97)
  instr = {8'hab, op_set};
  #(16)
  instr = {8'h00, op_dec};
  #(16)
  instr = {8'hcd, op_jz};
  #(16)
  instr = {8'h00, op_set};
  #(16)
  instr = {8'hef, op_jz};
  #(16)
  $finish;
end

endmodule