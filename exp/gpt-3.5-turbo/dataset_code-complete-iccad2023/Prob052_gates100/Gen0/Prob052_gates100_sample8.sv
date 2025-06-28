module TopModule (
  input [99:0] in,
  output out_and,
  output out_or,
  output out_xor
);

assign out_and = &in; // perform bitwise AND operation on all 100 inputs
assign out_or = |in; // perform bitwise OR operation on all 100 inputs
assign out_xor = ^in; // perform bitwise XOR operation on all 100 inputs

endmodule