module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimal SOP: out_sop = b c d + a b d'
  assign out_sop = (b & c & d) | (a & b & ~d);

  // Minimal POS: out_pos = (a + b + ~c)(a + ~b + d)
  assign out_pos = (a | b | ~c) & (a | ~b | d);

endmodule