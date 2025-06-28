module TopModule (
  input [3:0] x,
  output logic f
);

  // Define the individual input bits
  logic x1 = x[3];
  logic x2 = x[2];
  logic x3 = x[1];
  logic x4 = x[0];

  // Implement the function f based on the Karnaugh map conditions
  assign f = (x1 & !x2 & x4) | (!x1 & x3 & x2) | (x1 & x2 & x3) | (x1 & !x2 & !x3 & x4);

endmodule