module TopModule (
  input [4:1] x,
  output logic f
);

  // Extract variables for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // Karnaugh map minterms with value 1:
  // Row (x1 x2): 00, 01, 11, 10
  // Col (x3 x4): 00, 01, 11, 10
  // Map values:
  // 00  01  11  10
  // 1   0   0   1    (row 00)
  // 0   0   0   0    (row 01)
  // 1   1   1   0    (row 11)
  // 1   1   0   1    (row 10)

  // Minterms (x1x2x3x4) with value 1:
  // 0000 (x1=0,x2=0,x3=0,x4=0)
  // 0010 (x1=0,x2=0,x3=1,x4=0)
  // 1100 (x1=1,x2=1,x3=0,x4=0)
  // 1101 (x1=1,x2=1,x3=0,x4=1)
  // 1110 (x1=1,x2=1,x3=1,x4=0)
  // 1000 (x1=1,x2=0,x3=0,x4=0)
  // 1001 (x1=1,x2=0,x3=0,x4=1)
  // 1010 (x1=1,x2=0,x3=1,x4=0)
  // 1011 (x1=1,x2=0,x3=1,x4=1)
  
  // Minimized groups:
  // Group 1: x1=1 and x3=0 -> covers minterms with x1=1,x3=0
  // (1000,1001,1100,1101)
  // Group 2: x1=1 and x4=1 and x2=0 and x3=1 -> (1011)
  // Group 3: x1=0 and x2=0 and x4=0 and x3=0 or 1 (0000,0010)
  // Group 4: x1=1,x2=1,x3=1,x4=0 (1110)
  // Group 5: x1=1,x2=0,x3=1,x4=0 (1010)

  // Further simplification:
  // From groups: 
  // (1000,1001,1100,1101) => x1 & ~x3
  // (0000,0010) => ~x1 & ~x2 & ~x4
  // (1110) => x1 & x2 & x3 & ~x4
  // (1010) => x1 & ~x2 & x3 & ~x4
  // (1011) => x1 & ~x2 & x3 & x4

  // Notice that (1010) and (1011) differ only in x4, so can be combined:
  // x1 & ~x2 & x3

  // Final expression:
  // f = (x1 & ~x3) | (~x1 & ~x2 & ~x4) | (x1 & x2 & x3 & ~x4) | (x1 & ~x2 & x3)

  // Note x1 & ~x3 covers (1000,1001,1100,1101)
  // x1 & ~x2 & x3 covers (1010,1011)
  // x1 & x2 & x3 & ~x4 covers (1110)
  // ~x1 & ~x2 & ~x4 covers (0000,0010)

  assign f = (x1 & ~x3) | (~x1 & ~x2 & ~x4) | (x1 & x2 & x3 & ~x4) | (x1 & ~x2 & x3);

endmodule