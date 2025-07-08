module TopModule (
  input [4:1] x,
  output logic f
);

  // Karnaugh map from problem:
  // x[1]x[2]\x[3]x[4]: 00  01  11  10
  // 00                 1   0   0   1
  // 01                 0   0   0   0
  // 11                 1   1   1   0
  // 10                 1   1   0   1

  // The minterms where f=1 are:
  // Row 00 (x[1]=0,x[2]=0): col 00 (x[3]=0,x[4]=0) => 0000 (0)
  //                        col 10 (x[3]=1,x[4]=0) => 0010 (2)
  // Row 11 (x[1]=1,x[2]=1): col 00 (x[3]=0,x[4]=0) => 1100 (12)
  //                        col 01 (x[3]=0,x[4]=1) => 1101 (13)
  //                        col 11 (x[3]=1,x[4]=1) => 1111 (15)
  // Row 10 (x[1]=1,x[2]=0): col 00 (x[3]=0,x[4]=0) => 1000 (8)
  //                        col 01 (x[3]=0,x[4]=1) => 1001 (9)
  //                        col 10 (x[3]=1,x[4]=0) => 1010 (10)

  // Also row 10 col 10 is 1, and row 00 col 00 is 1, row 10 col 11 is 1?
  // Actually row 10 col 11 is 0 (given).
  // Row 00 col 10 is 1 (given).
  // Row 10 col 11 is 0.
  // Row 00 col 00 is 1.
  
  // Wait the problem states row 10 col 10 is 1, also row 10 col 01 is 1.

  // We can write the minterms as:
  // m0 = 0000
  // m2 = 0010
  // m8 = 1000
  // m9 = 1001
  // m10=1010
  // m12=1100
  // m13=1101
  // m15=1111

  // Also check row 11 col 11 is 1, so m15=1111

  // So f = Σ m(0,2,8,9,10,12,13,15)

  // Now simplify:
  // Group1: m8(1000), m9(1001), m10(1010) => x[1]=1,x[2]=0,x[3]=0 or 1, x[4]=don't care when matching
  // Actually grouping m8(1000), m9(1001) differ in x4, so group x[1]=1,x[2]=0,x[3]=0
  // m10(1010) differ in x3 from m8 and m9

  // Let's consider simpler groups:
  // Group m0(0000), m2(0010): x[1]=0,x[2]=0,x[3]=0 or 1,x[4]=0
  // Group m12(1100), m13(1101), m15(1111): x[1]=1,x[2]=1,x[3] and x[4] varies.
  // Check m12,13,15:
  // m12=1100, m13=1101 differ in x4
  // m15=1111 differ in x3 and x4
  // So group m12,13 together: x[1]=1,x[2]=1,x[3]=0,x[4]=don't care
  // m15(1111) separate

  // After simplification, the expression can be:
  // f = (~x1 & ~x2 & ~x4) & (some condition on x3)
  // or better to implement as a case or sum of minterms

  // To keep it clear, implement using a case statement with all minterms

  always_comb begin
    case (x)
      4'b0000,
      4'b0010,
      4'b1000,
      4'b1001,
      4'b1010,
      4'b1100,
      4'b1101,
      4'b1111: f = 1;
      default: f = 0;
    endcase
  end

endmodule