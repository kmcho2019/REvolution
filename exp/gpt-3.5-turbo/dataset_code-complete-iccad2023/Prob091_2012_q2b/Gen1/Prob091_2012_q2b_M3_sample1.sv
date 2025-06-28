module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = y[0] | y[5]; // Set Y1 if current state is B or F
  assign Y3 = y[2] | y[4]; // Set Y3 if current state is C or E

endmodule