module TopModule (
  input [4:1] x,
  output logic f
);

  // Mapping the variables for clarity:
  // Rows (x[4] x[3]): 00, 01, 11, 10
  // Columns (x[1] x[2]): 00, 01, 11, 10
  //
  // K-map with f values (d = don't-care):
  //         00   01   11   10
  // 00 |  d |  0 |  d |  d |
  // 01 |  0 |  d |  1 |  0 |
  // 11 |  1 |  1 |  d |  d |
  // 10 |  1 |  1 |  0 |  d |

  // From this map:
  // Group 1: The four 1's in rows 10 and 11, columns 00 and 01:
  // (x[4]x[3]) = 11 or 10 (x[4]=1), and (x[1]x[2])=00 or 01 (x[2]=0)
  // So group1 = x[4] & ~x[2]
  //
  // Group 2: single 1 at (01,11): row=01 (x[4]=0,x[3]=1), col=11 (x[1]=1,x[2]=1)
  // but it's a single 1, so f = ~x[4] & x[3] & x[1] & x[2]
  //
  // Group 3: single 1 at (11,00) and (11,01) already in group1
  //
  // So final simplified expression:
  // f = x[4] & ~x[2] | (~x[4] & x[3] & x[1] & x[2])

  assign f = (x[4] & ~x[2]) | (~x[4] & x[3] & x[1] & x[2]);

endmodule