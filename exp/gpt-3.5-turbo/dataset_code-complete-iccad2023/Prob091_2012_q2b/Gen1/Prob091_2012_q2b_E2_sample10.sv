module TopModule (
  input [5:0] y,
  input w,
  output Y1,
  output Y3
);

  // State machine transitions
  assign Y1 = (y[4] & !y[2]) | (y[3] & y[5]) | (y[0] & !y[4]); // Transitions B to C, C to E, F to C
  assign Y3 = (y[3] & y[5]) | (y[0] & !y[4]); // Transitions C to E, F to C

endmodule