module TopModule (
  input x3,
  input x2,
  input x1,
  output f
);
  
  // Implementing the minterms expressed in the truth table directly
  assign f = x1 & ~x2 & ~x3 | x1 & x2 & ~x3 | x1 & x2 & x3 | ~x1 & x2 & x3;

endmodule