module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  assign Y1 = y[1] & (w | y[2]); // Y1 depends on current state B and transitions to C or D
  assign Y3 = y[3] & (w | y[4]); // Y3 depends on current state D and transitions to E or A

endmodule