module TopModule(input [3:0] in, output out_and, out_or, out_xor);
  wire and0, and1;
  wire or0, or1;
  wire xor0, xor1;

  // Pairwise AND
  assign and0 = in[0] & in[1];
  assign and1 = in[2] & in[3];
  assign out_and = and0 & and1;

  // Pairwise OR
  assign or0 = in[0] | in[1];
  assign or1 = in[2] | in[3];
  assign out_or = or0 | or1;

  // Pairwise XOR
  assign xor0 = in[0] ^ in[1];
  assign xor1 = in[2] ^ in[3];
  assign out_xor = xor0 ^ xor1;
endmodule