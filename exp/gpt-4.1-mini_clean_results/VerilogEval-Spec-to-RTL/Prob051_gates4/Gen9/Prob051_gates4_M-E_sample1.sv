module TopModule(input [3:0] in, output out_and, out_or, out_xor);
  wire and_stage1, and_stage2;
  wire or_stage1, or_stage2;
  wire xor_stage1, xor_stage2;

  // 4-input AND as two 2-input AND gates then AND their outputs
  assign and_stage1 = in[0] & in[1];
  assign and_stage2 = in[2] & in[3];
  assign out_and = and_stage1 & and_stage2;

  // 4-input OR as two 2-input OR gates then OR their outputs
  assign or_stage1 = in[0] | in[1];
  assign or_stage2 = in[2] | in[3];
  assign out_or = or_stage1 | or_stage2;

  // 4-input XOR as two 2-input XOR gates then XOR their outputs
  assign xor_stage1 = in[0] ^ in[1];
  assign xor_stage2 = in[2] ^ in[3];
  assign out_xor = xor_stage1 ^ xor_stage2;
endmodule