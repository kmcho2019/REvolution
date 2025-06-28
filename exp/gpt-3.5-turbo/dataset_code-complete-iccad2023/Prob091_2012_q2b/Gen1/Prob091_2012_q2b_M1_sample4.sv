module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

assign Y1 = y[2] | y[3]; // Next state for Y1 transitions from state B to either C or D
assign Y3 = y[2] | y[3] | y[4] | y[5]; // Next state for Y3 transitions from state C to either E or D

endmodule