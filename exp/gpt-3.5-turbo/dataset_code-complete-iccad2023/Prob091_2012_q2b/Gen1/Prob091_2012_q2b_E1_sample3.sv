module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = (y[0] & w) | (y[1] & y[4]) | (y[4] & !y[5]);
  assign Y3 = (y[1] & y[4]) | (y[4] & !y[5]);

endmodule