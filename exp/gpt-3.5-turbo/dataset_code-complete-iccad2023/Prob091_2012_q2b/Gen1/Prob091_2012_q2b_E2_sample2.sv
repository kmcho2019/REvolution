module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Transition logic for Y1 based on state transitions A -> B -> C -> E and F -> C
  assign Y1 = (y[0] & w) | (y[1] & ~w) | (y[2] & w) | (y[3] & ~w) | (y[5] & ~w);

  // Transition logic for Y3 based on state transitions A -> D, B -> D, and E -> D
  assign Y3 = (y[0] & ~w) | (y[1] & ~w) | (y[4] & ~w);

endmodule