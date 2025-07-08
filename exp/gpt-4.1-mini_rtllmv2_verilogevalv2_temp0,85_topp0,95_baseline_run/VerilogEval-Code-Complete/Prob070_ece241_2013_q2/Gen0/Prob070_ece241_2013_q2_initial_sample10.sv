module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Inputs as bits: a (MSB), b, c, d (LSB)
  // Output=1 for decimal 2,7,15:
  // 2  = 0010 -> a=0,b=0,c=1,d=0
  // 7  = 0111 -> a=0,b=1,c=1,d=1
  // 15 = 1111 -> a=1,b=1,c=1,d=1

  // Minimal SOP expression obtained via Karnaugh map or Boolean simplification:
  // out_sop = (~a & ~b & c & ~d) + (~a & b & c & d) + (a & b & c & d)
  // This can't be further simplified meaningfully.

  // Minimal POS expression (minimize for zeros):
  // Output=0 for 0,1,4,5,6,9,10,13,14
  // After simplification (from K-map), minimal POS is:
  // out_pos = (a + b + ~c + ~d) & (a + ~b + c + d) & (~a + b + c + d)

  wire not_a = ~a;
  wire not_b = ~b;
  wire not_c = ~c;
  wire not_d = ~d;

  // SOP implementation
  assign out_sop = (not_a & not_b & c & not_d)
                 | (not_a & b & c & d)
                 | (a & b & c & d);

  // POS implementation
  assign out_pos = (a | b | not_c | not_d)
                 & (a | not_b | c | d)
                 & (not_a | b | c | d);

endmodule