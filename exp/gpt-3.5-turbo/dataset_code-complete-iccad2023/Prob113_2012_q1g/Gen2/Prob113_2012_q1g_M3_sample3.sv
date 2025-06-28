module TopModule (
  input [3:0] x,
  output logic f
);

  assign f = (x[0] & !x[1]) | (!x[0] & x[1] & !x[2]) | (x[0] & x[2]) | (x[1] & !x[2]);

endmodule