module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f using the provided Karnaugh map values
assign f = x[1] & !x[2] | !x[1] & x[2] & x[3] | x[1] & x[4];

endmodule