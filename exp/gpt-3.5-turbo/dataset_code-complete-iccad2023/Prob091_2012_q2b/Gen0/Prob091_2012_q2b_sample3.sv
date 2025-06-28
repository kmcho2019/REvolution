module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

assign Y1 = y[0] | y[4]; // next state for Y1 is the OR of current states A and E
assign Y3 = y[1] | y[5]; // next state for Y3 is the OR of current states B and F

endmodule