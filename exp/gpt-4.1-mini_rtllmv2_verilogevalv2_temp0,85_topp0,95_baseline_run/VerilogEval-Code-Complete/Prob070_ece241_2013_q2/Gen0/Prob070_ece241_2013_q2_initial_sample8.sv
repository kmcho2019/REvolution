module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimal SOP expression for out_sop = Σm(2,7,15)
  // out_sop = a b d + a c d' + b c d
  assign out_sop = (a & b & d) | (a & c & ~d) | (b & c & d);

  // Minimal POS expression for out_pos = ΠM(0,1,4,5,6,9,10,13,14)
  // out_pos = (a + b + c + ~d)(~a + b + d)(a + ~b + c + d)
  assign out_pos = (a | b | c | ~d) & (~a | b | d) & (a | ~b | c | d);

endmodule