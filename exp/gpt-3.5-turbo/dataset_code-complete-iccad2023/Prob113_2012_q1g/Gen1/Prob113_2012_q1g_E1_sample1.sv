module TopModule (
  input [4:1] x,
  output logic f
);

  // Simplified Boolean expression directly translated from the Karnaugh map
  assign f = (x[2] & ~x[1]) | (x[1] & ~x[3] & ~x[4]) | (x[3] & ~x[4]);

endmodule