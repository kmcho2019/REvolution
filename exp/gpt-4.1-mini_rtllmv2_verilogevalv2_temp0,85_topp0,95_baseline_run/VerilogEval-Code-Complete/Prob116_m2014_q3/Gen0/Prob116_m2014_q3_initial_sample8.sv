module TopModule (
  input [4:1] x,
  output logic f
);
  // f = (x[3] & ~x[1]) | (x[1] & x[2])
  assign f = (x[3] & ~x[1]) | (x[1] & x[2]);
endmodule