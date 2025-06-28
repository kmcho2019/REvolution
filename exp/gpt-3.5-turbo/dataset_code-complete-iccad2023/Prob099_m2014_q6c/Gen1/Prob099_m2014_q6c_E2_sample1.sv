module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

  assign Y2 = y[4]; // Y2 for state A
  assign Y2 = y[1]; // Y2 for state B
  assign Y2 = y[2]; // Y2 for state C and D
  assign Y2 = y[1]; // Y2 for state E and F

  assign Y4 = y[4]; // Y4 for states A, B, E
  assign Y4 = y[2]; // Y4 for states C, D
  assign Y4 = y[1]; // Y4 for state F

endmodule