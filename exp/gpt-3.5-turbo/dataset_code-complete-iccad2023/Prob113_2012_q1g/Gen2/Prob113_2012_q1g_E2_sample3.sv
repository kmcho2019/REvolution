module TopModule (
  input [4:1] x,
  output logic f
);

// Implementing the function using bitwise AND and OR operations
assign f = 
  (x[4] & ~x[3] & ~x[2] & x[1]) |  // Minterm 1
  (~x[4] & ~x[3] & ~x[2] & ~x[1]) | // Minterm 2
  (x[4] & x[3] & x[2] & ~x[1]) |    // Minterm 3
  (x[4] & x[3] & ~x[2] & x[1]);      // Minterm 4

endmodule