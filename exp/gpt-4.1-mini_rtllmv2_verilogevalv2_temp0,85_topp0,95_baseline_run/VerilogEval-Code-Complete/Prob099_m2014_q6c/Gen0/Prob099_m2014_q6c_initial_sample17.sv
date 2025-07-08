module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Y2 (state B) next-state logic:
  // from A (y[1]) with w=0: y[1] & ~w
  // from C (y[3]) with w=1: y[3] & w
  assign Y2 = (y[1] & ~w) | (y[3] & w);

  // Y4 (state D) next-state logic:
  // from B (y[2]) with w=1: y[2] & w
  // from C (y[3]) with w=1: y[3] & w
  // from E (y[5]) with w=1: y[5] & w
  // from F (y[6]) with w=1: y[6] & w
  assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule