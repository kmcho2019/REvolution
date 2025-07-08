module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);
  // Minterms for output=1: 2(0010),7(0111),15(1111)
  // a,b,c,d correspond to bits: a=MSB, d=LSB
  // 2  = 0 0 1 0
  // 7  = 0 1 1 1
  // 15 = 1 1 1 1

  // Minimal SOP:
  // Grouping 7 (0111) and 15 (1111) => b=1,c=1,d=1 (a don't care)
  // 2 (0010) alone => a=0,b=0,c=1,d=0
  // SOP = (b & c & d) + (~a & ~b & c & ~d)

  assign out_sop = (b & c & d) | (~a & ~b & c & ~d);

  // Maxterms for output=0: 0,1,4,5,6,9,10,13,14
  // Positions: 
  // 0  = 0000
  // 1  = 0001
  // 4  = 0100
  // 5  = 0101
  // 6  = 0110
  // 9  = 1001
  // 10 = 1010
  // 13 = 1101
  // 14 = 1110

  // Minimal POS:
  // From maxterms, form product of sums covering these inputs
  // By inspection, minimal POS is: 
  // (a + b + ~c + d) & (a + ~b + c + d)
  // Explanation:
  // - (a + b + ~c + d) covers maxterms with c=0 and d=1 or a=1 or b=1
  // - (a + ~b + c + d) covers maxterms with b=0 and c=1 or a=1 or d=1

  assign out_pos = (a | b | ~c | d) & (a | ~b | c | d);

endmodule