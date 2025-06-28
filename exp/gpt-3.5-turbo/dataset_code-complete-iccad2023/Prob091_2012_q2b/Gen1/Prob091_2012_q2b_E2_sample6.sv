module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // Y1 input logic based on state transitions
  assign Y1 = (y[2] & w) | (y[5] & ~w);

  // Y3 input logic based on state transitions
  assign Y3 = (y[0] & ~w) | (y[1] & w) | (y[4] & w);

endmodule