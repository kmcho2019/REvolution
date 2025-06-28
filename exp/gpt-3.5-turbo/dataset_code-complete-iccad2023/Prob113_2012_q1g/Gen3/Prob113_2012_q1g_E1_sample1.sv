module TopModule (
  input [3:0] x,
  output logic f
);

  // Implement the function f using logical expressions from the minterms in the Karnaugh map
  assign f = 
    // Minterm logical expressions combined to form the function
    (x[3] & ~x[2] & ~x[1] & x[0]) |
    (~x[3] & ~x[2] & x[1] & ~x[0]) |
    (x[3] & x[2] & ~x[1] & ~x[0]) |
    (x[3] & x[2] & ~x[1] & x[0]);

endmodule