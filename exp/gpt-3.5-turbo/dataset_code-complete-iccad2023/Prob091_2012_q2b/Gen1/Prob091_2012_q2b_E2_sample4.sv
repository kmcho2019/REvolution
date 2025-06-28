module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Y1 generation based on state transitions
  assign Y1 = y[0] & ~w | y[1] & w;

  // Y3 generation based on state transitions
  assign Y3 = y[1] & ~w | y[2] & w;

endmodule