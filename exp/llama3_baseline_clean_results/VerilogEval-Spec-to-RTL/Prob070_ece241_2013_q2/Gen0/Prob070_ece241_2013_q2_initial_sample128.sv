module TopModule(a, b, c, d, out_sop, out_pos);
  input a, b, c, d;
  output out_sop, out_pos;

  // Sum-of-Products (SOP) form: includes terms for output = 1 conditions
  assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

  // Product-of-Sums (POS) form: includes terms for output = 0 conditions
  assign out_pos = ~( (a & b & ~c & ~d) & (a & ~b & c & ~d) & (a & ~b & ~c & d) & (~a & b & ~c & d) & (~a & ~b & ~c & ~d) & (~a & ~b & c & d) & (~a & b & c & ~d) & (~a & ~b & ~c & d) & (a & ~b & ~c & ~d) & (a & b & ~c & d) );

  // Alternatively, for POS, considering only the terms that matter
  // The rest are implied by the given conditions and don't change the result
  assign out_pos = ~( (~a & ~b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (a & ~b & ~c & ~d) | (a & b & ~c & d) | (a & ~b & c & d) );
endmodule