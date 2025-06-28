module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f by grouping adjacent 1s in the Karnaugh map
assign f = (x[1] & !x[2]) | (x[1] & x[4]) | (!x[1] & x[2] & x[3]);

endmodule