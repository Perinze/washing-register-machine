module timer # (
  parameter WIDTH = 16
) (
  input [WIDTH-1:0] set,
  input       load,
  output      irq,

  input clk,
  input rst_n
);

wire [WIDTH:0] cnt;
wire [WIDTH:0] cnt_next;
wire [WIDTH:0] cnt_next_or_load;
wire sign = cnt[WIDTH];

assign irq = cnt == 17'd0;

wire [WIDTH:0] set_ext;
assign set_ext = {1'b0, set};

assign cnt_next =
    ({(WIDTH+1){~sign}} & (cnt - 17'd1))
  | ({(WIDTH+1){ sign}} & 17'h1ffff);

assign cnt_next_or_load =
    ({(WIDTH+1){ load}} & set_ext)
  | ({(WIDTH+1){~load}} & cnt_next);

dffrs #(WIDTH+1) timer_dff (
  .dnxt(cnt_next_or_load),
  .qout(cnt),
  .clk(clk),
  .rst_n(rst_n)
);

endmodule