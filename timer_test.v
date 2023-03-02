`timescale 1s/1ms
module timer_test;

reg clk;
reg rst_n;

initial begin
    $dumpfile("timer_test.vcd");
    $dumpvars(0, timer_test);
end

always #(0.5)
  clk = ~clk;

initial begin
  clk <= 1'b0;
  rst_n <= 1'b0;
  #(1) rst_n <= 1'b1;
end

reg [15:0] set;
reg       load = 1'b0;
wire      irq;

timer timer0 (
  .set(set),
  .load(load),
  .irq(irq),
  .clk(clk),
  .rst_n(rst_n)
);

initial begin
  #(2)
  set <= 16'd7;
  #(1)
  load <= 1'b1;
  #(1)
  load <= 1'b0;
  #(12)
  $finish;
end

endmodule