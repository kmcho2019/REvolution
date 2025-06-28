module TopModule (
  input [4:1] x,
  output logic f
);

// Minterms extracted from the Karnaugh map
assign f = (x[3] & !x[2] & !x[1]) | (x[1] & x[4] & !x[3]) | (x[1] & !x[2] & !x[3]) | (x[3] & x[4]);

endmodule