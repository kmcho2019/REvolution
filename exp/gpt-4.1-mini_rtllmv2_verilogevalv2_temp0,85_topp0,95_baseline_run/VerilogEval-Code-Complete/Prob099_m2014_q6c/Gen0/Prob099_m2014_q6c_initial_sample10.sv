module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Next state B (y[2]) is reached only from A (y[1]) when w=0
  assign Y2 = y[1] & ~w;

  // Next state D (y[4]) is reached from B,C,E,F when w=1
  assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule