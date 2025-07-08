module TopModule (
  input [4:1] x,
  output logic f
);

  // Assign variables for clarity
  wire x1 = x[1];
  wire x2 = x[2];
  wire x3 = x[3];
  wire x4 = x[4];

  // From Karnaugh map:
  // Rows (x3 x4): 00, 01, 11, 10
  // Columns (x1 x2): 00, 01, 11, 10
  //
  // Mapping values with d = don't-care:
  // (x3x4, x1x2): value
  // 00,00: d (don't care)
  // 00,01: 0
  // 00,11: d
  // 00,10: d
  // 01,00: 0
  // 01,01: d
  // 01,11: 1
  // 01,10: 0
  // 11,00: 1
  // 11,01: 1
  // 11,11: d
  // 11,10: d
  // 10,00: 1
  // 10,01: 1
  // 10,11: 0
  // 10,10: d

  // Using don't-cares to simplify, groups of 1:
  // Group 1: (11,00), (11,01), (10,00), (10,01) = x3=1 and x4=don't-care, x1=0 and x2=don't-care
  // Group 2: (01,11) alone (since neighbors have 0 or don't care), but 01,11 = x3=0, x4=1, x1=1, x2=1
  //
  // Group 1 corresponds to x3 & ~x1
  // Group 2 corresponds to ~x3 & x4 & x1 & x2
  //
  // So f = (x3 & ~x1) | (~x3 & x4 & x1 & x2)

  assign f = (x3 & ~x1) | (~x3 & x4 & x1 & x2);

endmodule