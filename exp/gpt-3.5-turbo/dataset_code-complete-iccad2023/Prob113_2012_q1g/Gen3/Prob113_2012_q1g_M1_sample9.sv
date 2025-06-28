module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f by simplifying the Karnaugh map
assign f = !x[3] & (!x[2] & x[1] | x[4] & x[1] | x[2] & !x[1]);

endmodule