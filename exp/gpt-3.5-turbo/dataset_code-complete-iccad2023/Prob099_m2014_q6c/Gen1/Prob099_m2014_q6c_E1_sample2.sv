module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

assign Y2 = y[1] & (y[2] | (y[4] & ~w) | (y[5] & w) | y[6]);
assign Y4 = (y[3] & ~w) | (y[5] & w) | y[6];

endmodule