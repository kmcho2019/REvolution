module TopModule (
  input [3:0] in,
  output out_and,
  output out_or,
  output out_xor
);

  assign out_and = &in;  // AND reduction of all bits in 'in'
  assign out_or  = |in;  // OR reduction of all bits in 'in'
  assign out_xor = ^in;  // XOR reduction of all bits in 'in'

endmodule