module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f using simplified logical expressions
assign f = (x[1] & x[4]) | (x[1] & !x[2]) | (x[2] & x[3]) | (!x[1] & x[2] & !x[3]);

endmodule