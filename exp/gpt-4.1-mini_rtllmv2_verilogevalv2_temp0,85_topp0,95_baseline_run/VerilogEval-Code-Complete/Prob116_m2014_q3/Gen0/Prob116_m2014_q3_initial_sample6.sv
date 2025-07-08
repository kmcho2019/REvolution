module TopModule (
  input [4:1] x,
  output logic f
);
  // Assign inputs to meaningful names for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // Karnaugh map interpretation:
  // rows = x3 x4: 00,01,11,10
  // cols = x1 x2: 00,01,11,10
  //
  // Map entries:
  // 00  | d | 0 | d | d |
  // 01  | 0 | d | 1 | 0 |
  // 11  | 1 | 1 | d | d |
  // 10  | 1 | 1 | 0 | d |
  //
  // Let's find groups:
  //
  // Ones at:
  // (11,00), (11,01), (01,11), (10,00), (10,01), (11,00)
  //
  // Considering don't-cares, form groups:
  //
  // Group 1: rows 10 and 11, columns 00 and 01 -> covers f=1 in positions (10,00),(10,01),(11,00),(11,01)
  //   These correspond to:
  //   x3 x4 = 1 0 and 1 1, x1 x2 = 0 0 and 0 1
  //   x3=1, x1=0
  //
  // Group 2: single 1 at (01,11) (row=01, col=11), only 1 in that column and row
  //   x3 x4 = 0 1, x1 x2 = 1 1
  //   x4=1, x1=1, x2=1
  //
  // So expression can be:
  // f = (x3 & ~x1) | (~x3 & x4 & x1 & x2)
  //
  // This expression covers all 1s, and uses don't-cares to simplify grouping.

  assign f = (x3 & ~x1) | (~x3 & x4 & x1 & x2);

endmodule