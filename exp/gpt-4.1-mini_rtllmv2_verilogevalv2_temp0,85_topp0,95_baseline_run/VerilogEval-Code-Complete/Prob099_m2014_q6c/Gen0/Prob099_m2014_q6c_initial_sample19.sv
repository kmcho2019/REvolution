module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Next state B (y[2]) is set if currently in A (y[1]) and input is 0
  assign Y2 = y[1] & ~w;

  // Next state D (y[4]) is set if input is 1 and currently in B, C, E, or F
  assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule