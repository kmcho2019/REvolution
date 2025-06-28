module TopModule (
  input [99:0] in,
  output out_and,
  output out_or,
  output out_xor
);

  wire [99:0] inter_and, inter_or, inter_xor;

  // 100-input AND gate
  assign inter_and = &in;
  assign out_and = inter_and[0];

  // 100-input OR gate
  assign inter_or = |in;
  assign out_or = inter_or[0];

  // 100-input XOR gate
  assign inter_xor = ^in;
  assign out_xor = inter_xor[0];

endmodule