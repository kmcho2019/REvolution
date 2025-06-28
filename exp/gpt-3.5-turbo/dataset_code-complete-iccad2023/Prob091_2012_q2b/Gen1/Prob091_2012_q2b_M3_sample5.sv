module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = (y == 6'b000010 || y == 6'b100000) ? w : 1'b0; // Inputs to flip-flop y[1] for transitions to B and F
  assign Y3 = (y == 6'b000100 || y == 6'b010000) ? w : 1'b0; // Inputs to flip-flop y[3] for transitions to C and E

endmodule