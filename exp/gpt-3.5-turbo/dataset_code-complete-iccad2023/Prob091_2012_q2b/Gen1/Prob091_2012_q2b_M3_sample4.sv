module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // State machine transitions per the given diagram
  assign Y1 = (y[1] & y[2]) | (y[2] & y[4]) | (y[5] & y[2]); // Transitions B to C, C to E, F to C
  assign Y3 = (y[2] & y[4]) | (y[5] & y[2]); // Transitions C to E, F to C

endmodule