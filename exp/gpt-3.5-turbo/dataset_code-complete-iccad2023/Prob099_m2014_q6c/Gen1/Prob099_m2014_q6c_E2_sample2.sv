module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  assign Y2 = (y[0] & ~w) | (y[1] & w) | (y[2] & ~w) | (y[5] & w);
  assign Y4 = (y[0] & ~w) | (y[2] & w) | (y[3] & ~w) | (y[1] & w);

endmodule