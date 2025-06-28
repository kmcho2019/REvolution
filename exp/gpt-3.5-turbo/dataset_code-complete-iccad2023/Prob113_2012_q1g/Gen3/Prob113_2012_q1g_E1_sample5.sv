module TopModule (
  input [3:0] x,
  output logic f
);

  // Define intermediate signals to represent each minterm
  logic minterm1 = x[3] & ~x[2] & x[0];
  logic minterm2 = ~x[3] & x[1] & x[2];
  logic minterm3 = x[3] & x[2] & x[1];
  logic minterm4 = x[3] & ~x[2] & ~x[1] & x[0];

  // Combine the minterms using bitwise logical OR operations to get the final output f
  assign f = minterm1 | minterm2 | minterm3 | minterm4;

endmodule