module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f by combining minterms to simplify the logic
assign f = (!x[1] & !x[2]) | (x[2] & x[3]) | (x[1] & x[2] & !x[3]) | (x[1] & !x[2] & x[4]);

endmodule