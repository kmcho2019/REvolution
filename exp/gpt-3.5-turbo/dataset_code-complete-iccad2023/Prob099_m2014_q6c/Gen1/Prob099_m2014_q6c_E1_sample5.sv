module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

assign Y2 = y[1] & ((y[1] & ~w) | (y[3] & w)); // Transition based on bit 1
assign Y4 = y[3] & ((y[3] & ~w) | (y[5] & w)); // Transition based on bit 3

endmodule