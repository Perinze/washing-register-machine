`timescale 1s/1ms
module rom_test;

initial begin
    $dumpfile("rom_test.vcd");
    $dumpvars(0, rom_test);
end

reg [7:0] pc;
wire [31:0] instr;

rom rom0 (
  .pc(pc),
  .instr(instr)
);

initial begin
  pc = 8'h00;
  #(1) pc = 8'h02;
  #(1) pc = 8'h03;
  #(1) pc = 8'h04;
  #(1) pc = 8'h05;
  #(1) pc = 8'h06;
  #(1) pc = 8'h07;
  #(1) pc = 8'h08;
  #(1) pc = 8'h02;
  #(1) pc = 8'h03;
  #(1) pc = 8'h04;
  #(1) $finish;
end

endmodule