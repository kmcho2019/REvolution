module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Decimal to binary: a b c d
  // 2  = 0 0 1 0
  // 7  = 0 1 1 1
  // 15 = 1 1 1 1
  
  // Minterms for output=1: m2(0010), m7(0111), m15(1111)
  // Zeros at: 0,1,4,5,6,9,10,13,14
  // Don't care: 3,8,11,12 (never occur)
  
  // Minimal SOP (sum of products) from Karnaugh map:
  // out_sop = (b & c & d) + (a & b & c & d) + (~a & ~b & c & ~d)
  // But m7 and m15 share (b & c & d), so m7 + m15 = b & c & d
  // So, out_sop = (b & c & d) + (~a & ~b & c & ~d)
  
  // Minimal POS (product of sums)
  // The zeros cover positions: 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
  // After minimization POS is: (a + b + ~c + d) & (a + ~b + c + d)
  // Using De Morgan and minimal forms, the final POS form is:
  // out_pos = (a + b + ~c + d) & (a + ~b + c + d)
  
  wire sop_part1, sop_part2;
  wire pos_part1, pos_part2;

  assign sop_part1 = b & c & d;
  assign sop_part2 = ~a & ~b & c & ~d;
  assign out_sop = sop_part1 | sop_part2;

  assign pos_part1 = a | b | ~c | d;
  assign pos_part2 = a | ~b | c | d;
  assign out_pos = pos_part1 & pos_part2;

endmodule