module TopModule (
  input [4:1] x,
  output logic f
);

  logic minterm1, minterm2, minterm3, minterm4, minterm5, minterm6, minterm7, minterm8;

  assign minterm1 = ~x[4] & ~x[3] & x[2] & ~x[1];
  assign minterm2 = ~x[4] & ~x[3] & ~x[2] & ~x[1];
  assign minterm3 = x[4] & ~x[3] & ~x[2] & ~x[1];
  assign minterm4 = x[4] & ~x[3] & x[2] & ~x[1];
  assign minterm5 = x[4] & x[3] & x[2] & ~x[1];
  assign minterm6 = x[4] & x[3] & ~x[2] & ~x[1];
  assign minterm7 = x[4] & x[3] & x[2] & ~x[1];
  assign minterm8 = ~x[4] & x[3] & x[2] & x[1];

  assign f = minterm1 | minterm3 | minterm4 | minterm5 | minterm6 | minterm7 | minterm8;

endmodule