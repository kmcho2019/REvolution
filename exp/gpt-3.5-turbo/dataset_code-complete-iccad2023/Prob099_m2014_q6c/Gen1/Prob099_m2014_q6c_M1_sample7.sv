module TopModule (
  input [6:1] y,
  input w,
  output Y2,
  output Y4
);

assign Y2 = y[4] | y[3] | y[1]; // Y2 transitions to 1 for states C, D, F
assign Y4 = y[5]; // Y4 transitions to 1 for state E

endmodule