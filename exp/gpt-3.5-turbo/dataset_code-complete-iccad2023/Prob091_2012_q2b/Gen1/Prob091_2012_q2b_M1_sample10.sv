module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

assign Y1 = y[0] & ~y[2] | y[2] & ~y[3]; // Input for Y1 based on transitions involving states A and C
assign Y3 = y[1] & ~y[3] | y[3] & ~y[4]; // Input for Y3 based on transitions involving states B and E

endmodule