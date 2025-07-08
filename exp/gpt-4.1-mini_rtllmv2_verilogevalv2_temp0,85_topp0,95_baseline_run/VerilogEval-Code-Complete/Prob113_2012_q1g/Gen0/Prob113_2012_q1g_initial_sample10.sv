module TopModule (
  input [4:1] x,
  output logic f
);
  // Assign row = x[1]x[2], col = x[3]x[4]
  // Karnaugh map:
  //      00  01  11  10
  // 00 | 1 | 0 | 0 | 1 |
  // 01 | 0 | 0 | 0 | 0 |
  // 11 | 1 | 1 | 1 | 0 |
  // 10 | 1 | 1 | 0 | 1 |

  // Minterms where f=1:
  // Row 00 (x[1]=0, x[2]=0)
  //  col 00 (x[3]=0, x[4]=0): 0000 = m0
  //  col 10 (x[3]=1, x[4]=0): 0010 = m2
  // Row 01 (01): none
  // Row 11 (11)
  //  col 00: 1100 = m12
  //  col 01: 1101 = m13
  //  col 11: 1111 = m15
  // Row 10 (10)
  //  col 00: 1000 = m8
  //  col 01: 1001 = m9
  //  col 10: 1010 = m10
  //  col 11: 1011 = m11 (0 in map, so not included)
  
  // So minterms: m0, m2, m8, m9, m10, m12, m13, m15

  // Simplify the function:
  // Grouping and simplification:
  // Group1: m8, m9, m10 (1000, 1001, 1010) -> x[1]=1, x[2]=0, x[3]=x, x[4]=x? 
  // Not exact because m11=1011 is zero
  // So group (m8, m9): x[1]=1, x[2]=0, x[3]=0, x[4]=x
  // and (m10): 1010 alone
  // Group2: m12, m13: 1100,1101 x[1]=1, x[2]=1, x[3]=0, x[4]=x
  // m15=1111: x[1]=1,x[2]=1,x[3]=1,x[4]=1
  // Also m0 and m2: 0000 and 0010 x[1]=0,x[2]=0,x[3]=x,x[4]=0

  // Expression derived:
  // f = (~x1 & ~x2 & ~x4) // covers m0 (0000) and m2(0010)
  //    | (x1 & ~x2 & ~x3) // covers m8(1000), m9(1001)
  //    | (x1 & ~x2 & x3 & ~x4) // m10(1010)
  //    | (x1 & x2 & ~x3) // m12(1100), m13(1101)
  //    | (x1 & x2 & x3 & x4); // m15(1111)

  assign f = (~x[1] & ~x[2] & ~x[4]) 
           | (x[1] & ~x[2] & ~x[3]) 
           | (x[1] & ~x[2] & x[3] & ~x[4]) 
           | (x[1] & x[2] & ~x[3]) 
           | (x[1] & x[2] & x[3] & x[4]);

endmodule