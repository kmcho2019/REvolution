module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Y2 is 1 only when current state is A (y[1]) and input w is 0
  assign Y2 = ~w & y[1];

  // Y4 is 1 when:
  // 1. Current state is B (y[2]) and w is 1, or
  // 2. Current state is C (y[3]) and w is 1, or
  // 3. Current state is E (y[5]) and w is 1, or
  // 4. Current state is F (y[6]) and w is 1
  assign Y4 = w & (y[2] | y[3] | y[5] | y[6]);

endmodule