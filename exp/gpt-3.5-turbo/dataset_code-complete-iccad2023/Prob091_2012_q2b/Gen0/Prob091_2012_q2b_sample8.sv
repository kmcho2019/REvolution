module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = (y == 6'b000001 || y == 6'b100000) ? w : 1'b0; // B or F state transitions
  assign Y3 = (y == 6'b000100 || y == 6'b010000) ? w : 1'b0; // C or E state transitions

endmodule