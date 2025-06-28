module TopModule (
  input [4:1] x,
  output logic f
);

assign f = 
  // Direct translation of the Karnaugh map values
  // Filling in the simplified expressions
  // Cell 1
  !(x[1] & !x[2] & !x[3] & x[4]) ||
  // Cell 2
  0 ||
  // Cell 3
  (x[1] & x[2] & x[3] & !x[4]) ||
  // Cell 4
  (!x[1] & x[2] & x[3] & x[4]);

endmodule