module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  assign Y2 = y[3] & w | y[1] & (y[0] | y[2] | y[4] | y[5]);
  assign Y4 = y[1] & w | y[0] & (y[2] | y[3] | y[5]) | y[3] & y[4];

endmodule