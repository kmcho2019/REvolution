module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Next state for B (y[2]):
  // From A on w=0 -> B
  assign Y2 = y[1] & ~w;

  // Next state for D (y[4]):
  // From B,C,E,F on w=1 -> D
  assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule