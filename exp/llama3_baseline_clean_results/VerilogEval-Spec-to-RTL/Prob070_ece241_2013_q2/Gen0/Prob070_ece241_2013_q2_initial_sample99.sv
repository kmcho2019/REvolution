module TopModule(a, b, c, d, out_sop, out_pos);
  input a, b, c, d;
  output out_sop, out_pos;

  // Minimum sum-of-products form for out_sop
  // Minterms: 2 (0010), 7 (0111), 15 (1111)
  assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

  // Minimum product-of-sums form for out_pos
  // Maxterms: 0 (0000), 1 (0001), 4 (0100), 5 (0101), 6 (0110), 9 (1001), 10 (1010), 13 (1101), 14 (1110)
  assign out_pos = (a | b | c | d) & (a | ~b | c | d) & (a | b | ~c | d) & (a | b | c | ~d) & (~a | b | c | d) & (~a | b | ~c | d) & (~a | ~b | c | d) & (~a | ~b | ~c | d) & (~a | ~b | c | ~d);
endmodule