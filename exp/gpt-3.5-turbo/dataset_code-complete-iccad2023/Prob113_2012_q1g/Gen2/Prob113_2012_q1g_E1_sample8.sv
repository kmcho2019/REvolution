module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f by identifying prime implicants from the Karnaugh map and simplifying
assign f = (!x[1] & x[2]) | (x[1] & x[3]) | (x[1] & x[2] & !x[4]);

endmodule