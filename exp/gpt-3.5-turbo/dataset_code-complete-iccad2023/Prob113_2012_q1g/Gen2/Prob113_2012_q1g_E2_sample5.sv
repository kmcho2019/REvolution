module TopModule (
  input [4:1] x,
  output logic f
);

  // Implement the function using Karnaugh map simplification
  assign f = x[1] & (!x[2] | x[3]) | x[2] & x[4] | x[1] & x[3] & !x[4];

endmodule