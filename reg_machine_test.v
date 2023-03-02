`timescale 100ms/1ns
module reg_machine_test;

reg clk;
reg rst_n;

initial begin
    $dumpfile("reg_machine_test.vcd");
    $dumpvars(0, reg_machine_test);
end

always #(0.5)
  clk = ~clk;

initial begin
  clk <= 1'b0;
  rst_n <= 1'b0;
  #(2) rst_n <= 1'b1;
end

reg start = 1'd0;
wire ctrl_fill;
wire ctrl_release;
wire ctrl_forward;
wire ctrl_reverse;
wire sig_clean;
wire sig_rinse;
wire sig_dry;
wire sig_done;

reg_machine reg_machine0 (
  .start(start),
  .ctrl_fill(ctrl_fill),
  .ctrl_release(ctrl_release),
  .ctrl_forward(ctrl_forward),
  .ctrl_reverse(ctrl_reverse),
  .sig_clean(sig_clean),
  .sig_rinse(sig_rinse),
  .sig_dry(sig_dry),
  .sig_done(sig_done),
  .clk(clk),
  .rst_n(rst_n)
);

initial begin
  #(128) start <= 1'b1;
  #(2) start <= 1'b0;
  #(64) start <= 1'b1;
  #(2) start <= 1'b0;
  #(3072) rst_n <= 1'b0;
  #(1) rst_n <= 1'b1;
  #(1024) $finish;
end

endmodule