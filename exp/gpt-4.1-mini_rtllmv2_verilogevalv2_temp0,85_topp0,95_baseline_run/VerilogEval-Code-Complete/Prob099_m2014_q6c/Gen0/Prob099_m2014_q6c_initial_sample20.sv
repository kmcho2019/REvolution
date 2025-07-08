module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Y2 corresponds to next state B (y[2]):
  // Transition to B only from A (y[1]) when w=0
  assign Y2 = y[1] & ~w;

  // Y4 corresponds to next state D (y[4]):
  // Transitions to D from B(y[2]), C(y[3]), E(y[5]), F(y[6]) when w=1
  assign Y4 = (y[2] | y[3] | y[5] | y[6]) & w;

endmodule