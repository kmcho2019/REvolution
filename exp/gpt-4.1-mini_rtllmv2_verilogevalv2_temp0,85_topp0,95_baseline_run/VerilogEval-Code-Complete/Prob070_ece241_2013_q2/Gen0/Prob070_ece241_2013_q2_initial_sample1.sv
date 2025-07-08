module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Inputs as a 4-bit vector: a is MSB, d is LSB
  wire [3:0] in = {a,b,c,d};

  // Output = 1 for inputs 2,7,15 (binary):
  // 2  =  0010  (a=0,b=0,c=1,d=0)
  // 7  =  0111  (a=0,b=1,c=1,d=1)
  // 15 =  1111  (a=1,b=1,c=1,d=1)

  // From truth table, minimal SOP expression:
  // out_sop = (!a & !b & c & !d) + (!a & b & c & d) + (a & b & c & d)
  // Try to minimize:
  // Group 7 and 15: b=1, c=1, d=1, a can be 0 or 1 -> b c d
  // So, out_sop = (!a & !b & c & !d) + (b & c & d)

  assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

  // For out_pos, minimal POS covers zeros at:
  // 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
  // Don't cares: 3,8,11,12

  // Minimal POS expression:
  // out_pos = (a + b + c + d) & (a + b + !c + !d) & (!a + !b + !c + d)
  // Explanation:
  // - From zeros at 0 and 1 -> (a + b + c + d)
  // - From zeros at 4,5 -> (a + b + !c + !d)
  // - From zeros at 9,13 -> (!a + !b + !c + d)

  assign out_pos = (a | b | c | d) & (a | b | ~c | ~d) & (~a | ~b | ~c | d);

endmodule