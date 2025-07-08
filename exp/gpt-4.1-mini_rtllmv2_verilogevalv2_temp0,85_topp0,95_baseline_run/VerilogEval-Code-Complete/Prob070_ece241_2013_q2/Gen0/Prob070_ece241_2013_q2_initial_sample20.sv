module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // minterms for output=1: 2(0010),7(0111),15(1111)
  // SOP minterms: m2 = a'b'cd', m7 = a' b c d, m15 = a b c d
  // Minimize SOP:
  // m7 + m15 = b c d
  // So out_sop = a'b' c d + b c d
  // Factor c d: out_sop = c d (a'b' + b)
  // a'b' + b = a'b' + b = b + a'b' (no simpler than this)
  // Alternatively, write full SOP: out_sop = a'b' c d + b c d
  // Let's just implement this minimal SOP.

  assign out_sop = (~a & ~b & c & d) | (b & c & d);

  // Maxterms for output=0: 0,1,4,5,6,9,10,13,14
  // Write POS for these maxterms (M0, M1, M4, M5, M6, M9, M10, M13, M14)
  // POS = Π M0 M1 M4 M5 M6 M9 M10 M13 M14
  // Using Karnaugh map or boolean algebra to minimize POS:
  // From the minterms of 1, output=1 at 2,7,15 only.
  // The minimized POS expression is (a + b + c')(a + b' + d)(a' + b + d)
  // This is a known minimal POS from the minterms.
  // Implement the POS expression as out_pos.

  assign out_pos = (a | b | ~c) & (a | ~b | d) & (~a | b | d);

endmodule