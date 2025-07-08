module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

  // Map each cell to minterm for abcd (a is MSB of ab, c is MSB of cd)
  // Rows (cd): 00,01,11,10
  // Cols (ab): 00,01,11,10

  // Karnaugh map (cd\ab):
  //      00  01  11  10
  // 00 | 1 | 1 | 0 | 1 |
  // 01 | 1 | 0 | 0 | 1 |
  // 11 | 0 | 1 | 1 | 1 |
  // 10 | 1 | 1 | 0 | 0 |

  // Minterms where out=1:
  // cd ab
  // 00 00 = 0000 = m0
  // 00 01 = 0001 = m1
  // 00 10 = 0010 = m2
  // 01 00 = 0100 = m4
  // 01 10 = 0110 = m6
  // 10 00 = 1000 = m8
  // 10 01 = 1001 = m9
  // 11 01 = 1101 = m13
  // 11 10 = 1110 = m14
  // 11 11 = 1111 = m15
  // 10 10 = 1010 = m10 no
  // 01 01 = 0101 no
  // 01 11 = 0111 no
  // 10 11 = 1011 no
  // 00 11 = 0011 no
  // 11 00 = 1100 no

  // List of minterms where out=1: m0,m1,m2,m4,m6,m8,m9,m13,m14,m15

  // Simplify using K-map:

  // Group 1: m0,m1,m4,m8,m9 (cells with c=0 or 1, a=0 or 1, but d=0)
  // Observing: m0(0000),m1(0001),m4(0100),m8(1000),m9(1001)
  // This group covers a=0 or 1, b=0 or 0/1, c=0 or 1, d=0
  // Actually, grouping m0,m1,m8,m9 (d=0) with b=0 or 1, c=0, d=0
  // This is complex; let's try a different approach:
  
  // Let's express the minterms in terms of variables:
  // m0: a=0,b=0,c=0,d=0
  // m1: a=0,b=0,c=0,d=1
  // m2: a=0,b=1,c=0,d=0
  // m4: a=0,b=0,c=1,d=0
  // m6: a=0,b=1,c=1,d=0
  // m8: a=1,b=0,c=0,d=0
  // m9: a=1,b=0,c=0,d=1
  // m13: a=1,b=1,c=1,d=1
  // m14: a=1,b=1,c=1,d=0
  // m15: a=1,b=1,c=1,d=1

  // Groupings:
  // Group A: m0,m1 (a=0,b=0,c=0,d=0 or 1) => a'b'c' (d is irrelevant)
  // Group B: m2,m6 (a=0,b=1,c=0 or 1,d=0) => a b c' d' + a b c d' but since a=0, a'=1, so a'=1
  // Actually m2(0,1,0,0) and m6(0,1,1,0) => a'=1,b=1,d=0, c=don't care
  // So group B: a' b d'
  // Group C: m4 (0,0,1,0) and m6 (0,1,1,0) share a'=1, c=1, d=0 => a' c d'
  // Group D: m8,m9 (1,0,0,0/1) => a=1,b=0,c=0, d=don't care => a b' c'
  // Group E: m13,m14,m15 (1,1,1,d) => a b c

  // From above, group B and C overlap in a'=1, d=0 region, so combined they give a' d' (since b and c are don't care in m2,m4,m6)

  // So final groups:
  // 1) a'b'c' (m0,m1)
  // 2) a' d' (m2,m4,m6)
  // 3) a b' c' (m8,m9)
  // 4) a b c (m13,m14,m15)

  // The expression:
  // out = a'b'c' + a'd' + a b' c' + a b c

  // Implement this expression in Verilog.

  assign out = (~a & ~b & ~c) | (~a & ~d) | (a & ~b & ~c) | (a & b & c);

endmodule