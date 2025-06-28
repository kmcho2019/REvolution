module TopModule (
  input [99:0] in,
  output out_and,
  output out_or,
  output out_xor
);

  assign out_and = &in; // Bitwise AND operator for all inputs
  assign out_or = |in; // Bitwise OR operator for all inputs
  assign out_xor = ^in; // Bitwise XOR operator for all inputs

endmodule