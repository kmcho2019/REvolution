module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  // Determine next state Y2 based on current state and input w
  assign Y2 = (y[5] & w) | (y[4] & ~w) | (y[3] & y[2] & ~w);

  // Determine next state Y4 based on current state and input w
  assign Y4 = (y[5] & ~w) | (y[4] & w) | (y[2] & w) | (y[3] & w);

endmodule