module TopModule(input [3:0] in, output out_and, out_or, out_xor);
  wire and_mid1, and_mid2;
  wire or_mid1, or_mid2;
  wire xor_mid1, xor_mid2;

  // 4-input AND as ((in[0] & in[1]) & (in[2] & in[3]))
  and u_and1(and_mid1, in[0], in[1]);
  and u_and2(and_mid2, in[2], in[3]);
  and u_and3(out_and, and_mid1, and_mid2);

  // 4-input OR as ((in[0] | in[1]) | (in[2] | in[3]))
  or u_or1(or_mid1, in[0], in[1]);
  or u_or2(or_mid2, in[2], in[3]);
  or u_or3(out_or, or_mid1, or_mid2);

  // 4-input XOR as (((in[0] ^ in[1]) ^ in[2]) ^ in[3])
  xor u_xor1(xor_mid1, in[0], in[1]);
  xor u_xor2(xor_mid2, xor_mid1, in[2]);
  xor u_xor3(out_xor, xor_mid2, in[3]);
endmodule