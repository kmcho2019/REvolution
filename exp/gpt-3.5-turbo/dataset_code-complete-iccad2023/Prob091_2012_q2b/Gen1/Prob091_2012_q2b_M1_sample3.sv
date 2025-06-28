module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = (y[0] & ~y[5]) | (y[1] & w) | (y[2] & w);
  assign Y3 = (y[1] & ~w) | (y[2] & w) | (y[5] & w);

endmodule