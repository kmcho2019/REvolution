module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

assign Y2 = (y[6] & ~y[1] & ~w) | (y[4] & w);

assign Y4 = (y[1] & ~y[0] & ~w) | (y[2] & w);

endmodule