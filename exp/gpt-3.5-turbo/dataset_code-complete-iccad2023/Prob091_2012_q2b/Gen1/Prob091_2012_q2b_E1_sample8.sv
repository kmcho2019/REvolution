module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // State machine transitions for Y1 and Y3 based on the provided state transitions
  assign Y1 = (y[1] & !w) | (y[2] & w) | (y[5] & w);
  assign Y3 = (y[2] & w) | (y[5] & w);

endmodule