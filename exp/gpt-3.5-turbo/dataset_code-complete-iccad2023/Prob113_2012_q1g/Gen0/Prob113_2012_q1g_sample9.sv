module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f using logical AND and OR operations
assign f = (x[4] & x[1] & !x[2]) | (x[1] & !x[3] & !x[4]) | (!x[1] & x[2] & x[3]) | (!x[1] & x[4] & !x[3]);

endmodule