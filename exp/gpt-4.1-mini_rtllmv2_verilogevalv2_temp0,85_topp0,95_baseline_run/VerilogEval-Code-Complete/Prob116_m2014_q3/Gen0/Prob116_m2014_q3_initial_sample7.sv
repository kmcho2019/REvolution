module TopModule (
  input [4:1] x,
  output logic f
);
  // f = (x4 & ~x2) | (~x4 & x3 & x2 & x1)
  assign f = (x[4] & ~x[2]) | (~x[4] & x[3] & x[2] & x[1]);
endmodule