module TopModule (
  input [4:1] x,
  output logic f
);

  // Assign variables for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  /*
   Karnaugh map layout (rows: x1x2, columns: x3x4):
       00  01  11  10
  00 | 1 | 0 | 0 | 1 |
  01 | 0 | 0 | 0 | 0 |
  11 | 1 | 1 | 1 | 0 |
  10 | 1 | 1 | 0 | 1 |

  Minterms with 1:
  Row x1x2 = 00 (0), x3x4=00(0) => m0 = 1
  Row 00, col 10 => m2 = 1
  Row 11, col 00 => m12 = 1
  Row 11, col 01 => m13 = 1
  Row 11, col 11 => m15 = 1
  Row 10, col 00 => m8 = 1
  Row 10, col 01 => m9 = 1
  Row 10, col 10 => m10 = 1
  Row 10, col 11 => m11 = 0 (excluded)
  Row 01 entire row zero

  Corresponding minterms:
  m0, m2, m8, m9, m10, m12, m13, m15

  Let's find groups:

  - Group1: m8, m9, m10 (row 10, cols 00,01,10)
  - Group2: m12, m13, m15 (row 11, cols 00,01,11)
  - m0 and m2 are isolated but can be combined since column 00 and 10, row 00
  - m0 and m2 can be grouped vertically with m8 (row10 col00) and m10 (row10 col10)
  - Group3: m0, m2, m8, m10 (column 00 and 10, rows 00 and 10)

  Let's express groups:

  Group1 (m8,9,10): x1=1,x2=0 (10) fixed; x3x4 = 00,01,10
    - x1 & ~x2

  Group2 (m12,13,15): x1=1,x2=1 (11) fixed; x3x4 = 00,01,11
    - x1 & x2

  Group3 (m0,2,8,10): col 00 and 10; rows 00 and 10
    - x4=0 (since col 00 and 10 means x4=0)
    - x2=0 (rows 00 and 10 means x2=0)
    - So group3 = ~x2 & ~x4

  Final function:
    f = (x1 & ~x2) | (x1 & x2) | (~x2 & ~x4)

  Simplify:
    (x1 & ~x2) | (x1 & x2) = x1 & (~x2 | x2) = x1
  So,
    f = x1 | (~x2 & ~x4)

*/

  assign f = x1 | (~x2 & ~x4);

endmodule