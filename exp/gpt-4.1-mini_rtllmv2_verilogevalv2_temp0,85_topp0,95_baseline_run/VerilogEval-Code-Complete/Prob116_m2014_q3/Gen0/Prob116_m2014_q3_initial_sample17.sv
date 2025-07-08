module TopModule (
  input [4:1] x,
  output logic f
);

  // For clarity, assign variables
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // K-map entries as given:
  // Rows: x3x4 = 00,01,11,10
  // Cols: x1x2 = 00,01,11,10
  //
  //      00  01  11  10
  // 00 | d | 0 | d | d |
  // 01 | 0 | d | 1 | 0 |
  // 11 | 1 | 1 | d | d |
  // 10 | 1 | 1 | 0 | d |
  //
  // Analyze the map:
  // Let's list the minterms with output 1:
  // (x3x4, x1x2):
  // (11,00) => x4=1,x3=1,x2=0,x1=0 => m12 (binary 1100)
  // (11,01) => x4=1,x3=1,x2=0,x1=1 => m13 (1101)
  // (01,11) => x4=0,x3=1,x2=1,x1=1 => m7  (0111)
  // (10,00) => x4=1,x3=0,x2=0,x1=0 => m8  (1000)
  // (10,01) => x4=1,x3=0,x2=0,x1=1 => m9  (1001)
  //
  // Also, look at don't cares that can be used as 1 for simplification:
  // For example, (00,00) = d, (00,11) = d, (00,10)=d, (01,01)=d, (11,11)=d, (11,10)=d, (10,10)=d
  //
  // We can use these to group and simplify.
  //
  // Minimal sum-of-products expression (one possible):
  // f = (~x4 & x3) | (x4 & ~x3 & ~x2) | (x4 & x3 & ~x1)
  //
  // Explanation:
  // - (~x4 & x3): covers (01,00->d), (01,01->d), (01,11=1), (01,10=0), (11,00=1), (11,01=1), so mostly row 01 and 11 x3=1 & x4=0 or 1
  // Actually, to be precise:
  //
  // Group1: All cells with x3=1 and x4=0 or 1 and x1x2=01 or 00 or 11 that are 1 or d. From the map, the group (~x4 & x3) covers the two '1's at (11,00) and (11,01) and (01,11).
  //
  // Group2: (x4 & ~x3 & ~x2): covers (10,00)=1 and (10,01)=1, because x4=1, x3=0, x2=0
  //
  // Group3: (x4 & x3 & ~x1): covers (11,00)=1 and (11,01)=1 (because ~x1 matches x1=0), but (11,00) x1=0, (11,01) x1=1, so this covers only (11,00). Actually only one minterm, maybe part of another group.
  //
  // Let's re-check groups for better simplification:
  //
  // Group A: (~x4 & x3) covers minterms m4, m5, m6, m7: These correspond to x4=0, x3=1, any x1, x2:
  // From map, (01,00)=0, so not included; (01,01)=d; (01,11)=1; (01,10)=0
  // So not all ones.
  //
  // Group B: (x4 & ~x3 & ~x2) covers minterms m8 and m9 (10,00) and (10,01) = both 1
  //
  // Group C: (x4 & x3 & ~x1) covers m12 and m14 (11,00) and (11,10), but (11,10) is d
  //
  // Let's pick the simplified expression:
  //
  // f = (x3 & ~x4 & x1) | (x3 & x4 & ~x1) | (x4 & ~x3 & ~x2) | (x3 & x4 & x2)
  //
  // But maybe the simplest is to implement the function using the minterms for all 1s:
  //
  // Minterms:
  // m7: 0111  -> x4=0,x3=1,x2=1,x1=1
  // m8: 1000  -> x4=1,x3=0,x2=0,x1=0
  // m9: 1001  -> x4=1,x3=0,x2=0,x1=1
  // m12:1100  -> x4=1,x3=1,x2=0,x1=0
  // m13:1101  -> x4=1,x3=1,x2=0,x1=1
  //
  // Using these minterms, write OR of minterms:
  // f = ( ~x4 & x3 & x2 & x1 ) |
  //     ( x4 & ~x3 & ~x2 & ~x1 ) |
  //     ( x4 & ~x3 & ~x2 &  x1 ) |
  //     ( x4 & x3 & ~x2 & ~x1 ) |
  //     ( x4 & x3 & ~x2 &  x1 )
  //
  // Combine terms where possible:
  // (x4 & ~x3 & ~x2) & ( ~x1 | x1 ) = (x4 & ~x3 & ~x2)
  // (x4 & x3 & ~x2) & ( ~x1 | x1 ) = (x4 & x3 & ~x2)
  //
  // So final simplified expression:
  // f = (~x4 & x3 & x2 & x1) | (x4 & ~x3 & ~x2) | (x4 & x3 & ~x2)
  //
  // This is the minimal implementation.

  assign f = (~x4 & x3 & x2 & x1) | (x4 & ~x3 & ~x2) | (x4 & x3 & ~x2);

endmodule