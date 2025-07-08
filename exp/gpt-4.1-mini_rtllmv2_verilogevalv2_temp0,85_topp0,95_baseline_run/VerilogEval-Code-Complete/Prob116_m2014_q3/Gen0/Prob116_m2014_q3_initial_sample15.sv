module TopModule (
  input [4:1] x,
  output logic f
);

  // Assign variables for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // Analyzing the K-map:
  // Rows (x3x4): 00, 01, 11, 10
  // Cols (x1x2): 00, 01, 11, 10
  //
  // K-map table (row: x3x4, col: x1x2):
  //          00  01  11  10
  // 00: d    0   d   d
  // 01: 0    d   1   0
  // 11: 1    1   d   d
  // 10: 1    1   0   d
  //
  // Assign 1 to don't-cares (d) where it helps group
  //
  // Groups:
  // - Group1: The column x1x2=01 (col 1) rows 11 and 10: both 1 and also d in 01 row (d->1). So group (x1=0, x2=1) and (x3x4 = 1x)
  // - Group2: The bottom two rows (x3x4=11,10) columns 00 and 01 are 1: so x3=1 (row 11 and 10), x1x2=0x (col 00 and 01)
  // - Group3: The cell at row 11, col 00 and row 10, col 00: both 1
  //
  // Simplified expression:
  // f = x3 + (~x1 & x2 & x4')
  //
  // Explanation:
  // - The ones in rows 11 and 10 cover x3=1
  // - The 1 at row 01 col 11 and surrounding don't-cares suggest a smaller term for (x1=0, x2=1, x4=0)
  //
  // Final expression:
  // f = x3 | (~x1 & x2 & ~x4)
  
  assign f = x3 | (~x1 & x2 & ~x4);

endmodule