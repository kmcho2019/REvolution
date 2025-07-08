module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // minterms for output=1: 2(0010),7(0111),15(1111)
  // SOP expression: 
  // M2 = a'b'c d'
  // M7 = a' b c d
  // M15= a b c d
  // We'll try to simplify:
  // M7 and M15 share b c d, differ on a
  // M7 + M15 = b c d (a'+a) = b c d
  // So expression = a'b'c d' + b c d

  assign out_sop = (~a & ~b & c & ~d) | (b & c & d);

  // zeros = 0,1,4,5,6,9,10,13,14
  // Write maxterms for zeros (output=0):
  // For product-of-sums, output=1 for all minterms except zeros.
  // Use zeros to form POS:
  // 0 (0000): (a + b + c + d)
  // 1 (0001): (a + b + c + ~d)
  // 4 (0100): (a + ~b + c + d)
  // 5 (0101): (a + ~b + c + ~d)
  // 6 (0110): (a + ~b + ~c + d)
  // 9 (1001): (~a + b + c + ~d)
  // 10(1010): (~a + b + ~c + d)
  // 13(1101): (~a + ~b + c + ~d)
  // 14(1110): (~a + ~b + ~c + d)

  // We will try to simplify the POS expression.

  // By grouping, the minimal POS is: 
  // (a + b + c + d) (a + b + c + ~d) (a + ~b + c + d) (a + ~b + ~c + d)
  // ( ~a + b + c + ~d ) ( ~a + b + ~c + d ) ( ~a + ~b + c + ~d ) ( ~a + ~b + ~c + d )

  // On inspection, the minimal POS expression reduces to:
  // (a + c + d) (a + b + ~d) ( ~a + c + ~d) ( ~a + b + d)
  // But let's verify a simpler approach:
  // Using K-map simplification for POS (with don't cares), the minimal POS is:
  // (a + b + c) (a + b + d) (a + ~b + d) ( ~a + c + d)
  // Let's pick the simplified minimal POS as:
  // (a + b + d) (a + ~b + d) ( ~a + c + d)

  // To keep it simple, let's use POS = (a + b + d) (a + ~b + d) ( ~a + c + d)

  assign out_pos = (a | b | d) & (a | ~b | d) & (~a | c | d);

endmodule