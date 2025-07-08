module TopModule (
  input [4:1] x,
  output logic f
);

  // x[3]x[4] rows: 00,01,11,10
  // x[1]x[2] cols: 00,01,11,10
  // Mapping given:
  // (x3x4,x1x2) = value
  // 00,00 = d (don't care)
  // 00,01 = 0
  // 00,11 = d
  // 00,10 = d
  // 01,00 = 0
  // 01,01 = d
  // 01,11 = 1
  // 01,10 = 0
  // 11,00 = 1
  // 11,01 = 1
  // 11,11 = d
  // 11,10 = d
  // 10,00 = 1
  // 10,01 = 1
  // 10,11 = 0
  // 10,10 = d

  // Let's decode the variables as (for clarity):
  // Row: x3 x4
  // Col: x1 x2

  // Let's list all minterms (positions where f=1)
  // Positions:
  // (01,11) => x3=0,x4=1,x1=1,x2=1
  // (11,00) => x3=1,x4=1,x1=0,x2=0
  // (11,01) => x3=1,x4=1,x1=0,x2=1
  // (10,00) => x3=1,x4=0,x1=0,x2=0
  // (10,01) => x3=1,x4=0,x1=0,x2=1

  // Let's express these minterms:
  // m1: x3=0,x4=1,x1=1,x2=1  => ~x3 & x4 & x1 & x2
  // m2: x3=1,x4=1,x1=0,x2=0  => x3 & x4 & ~x1 & ~x2
  // m3: x3=1,x4=1,x1=0,x2=1  => x3 & x4 & ~x1 & x2
  // m4: x3=1,x4=0,x1=0,x2=0  => x3 & ~x4 & ~x1 & ~x2
  // m5: x3=1,x4=0,x1=0,x2=1  => x3 & ~x4 & ~x1 & x2

  // We can group:
  // Group 1: m2 & m3: x3 & x4 & ~x1
  // Group 2: m4 & m5: x3 & ~x4 & ~x1
  // Group 3: m1: ~x3 & x4 & x1 & x2

  // Combine Group 1 and Group 2:
  // x3 & ~x1 & (x4 + ~x4) = x3 & ~x1

  // So final simplified expression:
  // f = x3 & ~x1  +  (~x3 & x4 & x1 & x2)

  assign f = (x[3] & ~x[1]) | (~x[3] & x[4] & x[1] & x[2]);

endmodule