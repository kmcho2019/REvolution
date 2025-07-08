module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Y1: next state is B, reached from A (y[0]) when w=1
  assign Y1 = y[0] & w;

  // Y3: next state is D, reached from B, C, E, or F when w=0
  assign Y3 = (y[1] | y[2] | y[4] | y[5]) & (~w);

endmodule