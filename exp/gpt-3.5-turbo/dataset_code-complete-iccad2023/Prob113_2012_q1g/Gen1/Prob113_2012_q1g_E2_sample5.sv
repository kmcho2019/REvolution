module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f based on the simplified Boolean expression from the Karnaugh map
assign f = (x[1] & !x[3]) | (x[2] & x[3]) | (x[1] & !x[4]) | (x[4] & !x[3]);

endmodule