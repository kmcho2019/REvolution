module TopModule(input [3:0] in, output out_and, out_or, out_xor);

  wire and_lvl1_0, and_lvl1_1;
  wire or_lvl1_0, or_lvl1_1;
  wire xor_lvl1_0, xor_lvl1_1;

  // 4-input AND as two 2-input AND gates feeding a final 2-input AND
  and u_and0(and_lvl1_0, in[0], in[1]);
  and u_and1(and_lvl1_1, in[2], in[3]);
  and u_and_final(out_and, and_lvl1_0, and_lvl1_1);

  // 4-input OR as two 2-input OR gates feeding a final 2-input OR
  or u_or0(or_lvl1_0, in[0], in[1]);
  or u_or1(or_lvl1_1, in[2], in[3]);
  or u_or_final(out_or, or_lvl1_0, or_lvl1_1);

  // 4-input XOR as two 2-input XOR gates feeding a final 2-input XOR
  xor u_xor0(xor_lvl1_0, in[0], in[1]);
  xor u_xor1(xor_lvl1_1, in[2], in[3]);
  xor u_xor_final(out_xor, xor_lvl1_0, xor_lvl1_1);

endmodule