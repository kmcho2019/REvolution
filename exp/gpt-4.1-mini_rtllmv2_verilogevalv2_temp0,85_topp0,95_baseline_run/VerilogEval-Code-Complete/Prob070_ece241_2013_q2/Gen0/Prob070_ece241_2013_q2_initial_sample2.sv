module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimal SOP expression from K-map with don't cares:
  // output=1 for 2(0010),7(0111),15(1111)
  // After simplification:
  // out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d)

  assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

  // Minimal POS expression from K-map with don't cares:
  // out_pos = (a + b + ~c + d) & (a + ~b + c + d)

  assign out_pos = (a | b | ~c | d) & (a | ~b | c | d);

endmodule