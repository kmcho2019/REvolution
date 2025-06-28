module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  wire ab_xor, bc_xor, cd_xor;

  assign ab_xor = a ^ b;
  assign bc_xor = b ^ c;
  assign cd_xor = c ^ d;

  assign q = (ab_xor & (bc_xor | cd_xor)) | (bc_xor & cd_xor);

endmodule