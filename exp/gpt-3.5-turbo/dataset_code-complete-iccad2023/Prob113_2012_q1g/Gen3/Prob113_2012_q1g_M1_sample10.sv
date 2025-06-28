module TopModule (
  input [4:1] x,
  output logic f
);

// Define the function f using simplified logic expressions based on Karnaugh map
assign f = (!x[3] & !x[1]) | (x[4] & x[3] & x[1]) | (x[4] & !x[2]) | (!x[4] & x[1]);

endmodule