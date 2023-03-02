module rom (
  input   [7:0] pc,
  output [15:0] instr
);

reg [15:0] mem [0:64];

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
    mem[i] = 16'h0000;

  mem[02] = {8'd100, op_fill};
  mem[03] = {8'd050, op_wait};
  mem[04] = {8'd005, op_set};
  // loop start
  mem[05] = {8'd020, op_forward};
  mem[06] = {8'd010, op_wait};
  mem[07] = {8'd020, op_reverse};
  mem[08] = {8'd010, op_wait};
  mem[09] = {8'd000, op_dec};
  mem[10] = {8'd005, op_jnz};
  // loop end
  mem[11] = {8'd100, op_release};
end

endmodule