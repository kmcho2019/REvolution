module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Next state B logic (y[2])
  // Transition: A (y[1]) --0--> B
  assign Y2 = y[1] & ~w;

  // Next state D logic (y[4])
  // Transitions:
  // B (y[2]) --1--> D
  // C (y[3]) --1--> D
  // E (y[5]) --1--> D
  // F (y[6]) --1--> D
  assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule