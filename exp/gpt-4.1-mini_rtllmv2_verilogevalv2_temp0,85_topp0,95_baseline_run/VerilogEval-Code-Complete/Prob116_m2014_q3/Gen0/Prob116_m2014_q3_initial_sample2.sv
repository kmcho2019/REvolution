module TopModule (
  input [4:1] x,
  output logic f
);

  // f = x[4] & ~x[2] | x[3] & x[2] & x[1] | x[3] & x[4] & ~x[1]
  assign f = (x[4] & ~x[2]) | (x[3] & x[2] & x[1]) | (x[3] & x[4] & ~x[1]);

endmodule