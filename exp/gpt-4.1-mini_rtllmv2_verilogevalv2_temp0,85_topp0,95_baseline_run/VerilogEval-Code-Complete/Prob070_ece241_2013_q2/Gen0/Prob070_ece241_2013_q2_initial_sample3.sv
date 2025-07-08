module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimal SOP: out_sop = m2 + m7 + m15
  // m2 = ~a & ~b & c & ~d
  // m7 = ~a & b & c & d
  // m15= a & b & c & d
  assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

  // Minimal POS:
  // out_pos = (a + b + ~c + d) & (a + ~b + ~c + ~d) & (~a + b + c + d)
  assign out_pos = (a | b | ~c | d) & (a | ~b | ~c | ~d) & (~a | b | c | d);

endmodule