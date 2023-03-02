module timer (
  input [7:0] set,
  input       load,
  output      irq,

  input clk,
  input rst_n
);

wire [8:0] cnt;
wire [8:0] cnt_next;
wire [8:0] cnt_next_or_load;
wire sign = cnt[8];

assign irq = cnt == 9'd0;

wire [8:0] set_ext;
assign set_ext = {1'b0, set};

assign cnt_next =
    ({9{~sign}} & (cnt - 9'd1))
  | ({9{ sign}} & 9'h1ff);

assign cnt_next_or_load =
    ({9{ load}} & set_ext)
  | ({9{~load}} & cnt_next);

dffrs #(9) timer_dff (
  .dnxt(cnt_next_or_load),
  .qout(cnt),
  .clk(clk),
  .rst_n(rst_n)
);

endmodule