module TopModule (
  input [4:1] x,
  output logic f
);
  // x[4] = x4, x[3] = x3, x[2] = x2, x[1] = x1

  assign f = (x[3] & ~x[1]) | (~x[3] & x[4] & x[1] & x[2]);

endmodule