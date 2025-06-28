module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);
  
  wire ab_xor, ac_xor, ad_xor, bc_xor, bd_xor, cd_xor;
  wire odd_count;
  
  xor ab_xor_gate (ab_xor, a, b);
  xor ac_xor_gate (ac_xor, a, c);
  xor ad_xor_gate (ad_xor, a, d);
  xor bc_xor_gate (bc_xor, b, c);
  xor bd_xor_gate (bd_xor, b, d);
  xor cd_xor_gate (cd_xor, c, d);
  
  and odd_count_and (odd_count, ab_xor, ac_xor, ad_xor, bc_xor, bd_xor, cd_xor);
  
  assign q = odd_count;
  
endmodule