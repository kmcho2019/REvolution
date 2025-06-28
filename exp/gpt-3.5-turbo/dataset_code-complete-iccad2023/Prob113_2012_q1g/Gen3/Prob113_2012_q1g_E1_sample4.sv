module TopModule (
  input [3:0] x,
  output logic f
);

// Implement the function f using Karnaugh map simplification
assign f = x[3] & x[2] | x[2] & !x[1] | x[3] & !x[1] & !x[0] | x[3] & !x[2] & !x[1] & x[0];

endmodule