module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimum Sum of Products
  // out_sop = b c d + a' b' c d'
  assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

  // Minimum Product of Sums
  // out_pos = (a + b + d)(a + b' + c')(a' + c + d)
  assign out_pos = (a | b | d) & (a | ~b | ~c) & (~a | c | d);

endmodule