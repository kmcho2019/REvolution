module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimized SOP from Karnaugh map:
  // 1) Group minterm 2 (0010) and don't-care 3 (0011) => term: a' b' c d'
  // 2) Group minterm 7 (0111) and 15 (1111) with don't-care 11 (1011) and 3 (0011) to simplify, but 7 and 15 differ in a,b,c,d:
  // Let's check Karnaugh map grouping:

  // Let's write out the minterms and don't-cares:

  // Minterms (1): 2(0010),7(0111),15(1111)
  // Don't-cares: 3(0011),8(1000),11(1011),12(1100)

  // K-map (a,b across top, c,d on side):

  // cd \ ab | 00 | 01 | 11 | 10
  // ---------------------------
  // 00     |  0 |  0 |  0 |  0
  // 01     |  1 |  0 |  d |  d
  // 11     |  0 |  1 |  1 |  d
  // 10     |  d |  0 |  0 |  0

  // Let's map the inputs accordingly:
  // a,b:00=0,01=1,11=3,10=2 (since a=MSB)
  // c,d:00=0,01=1,11=3,10=2 (c=MSB)

  // Minterms:
  // 2 = 0010 (a=0,b=0,c=1,d=0) -> ab=00, cd=10 => cell (cd=10, ab=00) = 1
  // 7 = 0111 (a=0,b=1,c=1,d=1) -> ab=01, cd=11 => cell (cd=11, ab=01) =1
  // 15=1111 (a=1,b=1,c=1,d=1) -> ab=11, cd=11 => cell (cd=11, ab=11) =1

  // Don't cares:
  // 3=0011 (ab=00, cd=11) d
  // 8=1000 (ab=10, cd=00) d
  // 11=1011 (ab=10, cd=11) d
  // 12=1100 (ab=11, cd=00) d

  // Map cells:

  // cd\ab | 00 | 01 | 11 | 10
  // 00    |  0 |  0 |  d |  d  (0,0;0,1;1,1;1,0)
  // 01    |  0 |  0 |  0 |  0
  // 11    | d  |  1 |  1 |  d
  // 10    | 1  |  0 |  d |  0

  // Let's fill K-map properly:

  // cd=00 (c=0,d=0): ab=00(0),01(0),11(d12),10(d8)
  // cd=01 (c=0,d=1): ab=00(0),01(0),11(0),10(0)
  // cd=11 (c=1,d=1): ab=00(d3),01(1),11(1),10(d11)
  // cd=10 (c=1,d=0): ab=00(1),01(0),11(d?),10(0)

  // Actually 11(d?) at ab=11, cd=10 is 14=1110 which is 0

  // Final K-map:

  // cd\ab | 00 | 01 | 11 | 10
  // 00    |  0 |  0 |  d |  d
  // 01    |  0 |  0 |  0 |  0
  // 11    | d  |  1 |  1 |  d
  // 10    |  1 |  0 |  0 |  0

  // Groups:

  // Group1: (cd=11, ab=01 and 11): covers 7 and 15
  // Group2: (cd=10, ab=00): covers 2
  // Group3: Possible to include don't-cares to simplify group1 or group2

  // Group1: b=1, c=1, d=1 (b c d)
  // Group2: a=0, b=0, c=1, d=0 (a' b' c d')

  // SOP minimal: out_sop = b c d + a' b' c d'

  // For POS: output=0 maxterms: 0,1,4,5,6,9,10,13,14

  // Maxterms correspond to zeros in the truth table.

  // We write product of sums over zeros:

  // From K-map, minimal POS is:

  // out_pos = (a + b + d) (a + b' + c' + d) (a' + b + c) 

  // Let's verify this expression by double-checking coverage.

  // Alternatively, POS minimal expression can be derived as:

  // out_pos = (a + b + d)(a + b' + c' + d)(a' + b + c)

  // This covers all zeros.

  // Implement these two expressions.

  assign out_sop = (b & c & d) | (~a & ~b & c & ~d);
  assign out_pos = (a | b | d) & (a | ~b | ~c | d) & (~a | b | c);

endmodule