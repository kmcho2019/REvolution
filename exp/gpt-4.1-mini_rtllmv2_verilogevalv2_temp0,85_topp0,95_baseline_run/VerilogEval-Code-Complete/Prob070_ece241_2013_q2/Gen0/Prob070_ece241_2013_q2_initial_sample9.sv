module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Sum of Products (SOP) minimal expression:
  // out_sop = a b d + a c d' + a' b' c d
  wire term1_sop = a & b & d;
  wire term2_sop = a & c & ~d;
  wire term3_sop = ~a & ~b & c & d;
  assign out_sop = term1_sop | term2_sop | term3_sop;

  // Product of Sums (POS) minimal expression:
  // out_pos = (a + b + c + d) (a + b + c' + d') (a' + b' + c + d)
  wire term1_pos = a | b | c | d;
  wire term2_pos = a | b | ~c | ~d;
  wire term3_pos = ~a | ~b | c | d;
  assign out_pos = term1_pos & term2_pos & term3_pos;

endmodule