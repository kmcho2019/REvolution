module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Sum-of-products minimal expression:
  // out_sop = a b d + b c d'
  assign out_sop = (a & b & d) | (b & c & ~d);

  // Product-of-sums minimal expression:
  // out_pos = (a + b + d)(b + c' + d')(a' + b + c + d)
  assign out_pos = (a | b | d) & (b | ~c | ~d) & (~a | b | c | d);

endmodule