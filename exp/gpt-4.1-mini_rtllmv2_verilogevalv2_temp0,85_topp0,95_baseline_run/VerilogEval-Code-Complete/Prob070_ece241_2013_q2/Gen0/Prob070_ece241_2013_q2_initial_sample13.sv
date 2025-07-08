module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimal SOP: out_sop = a' b' c d' + b c d
  wire term1_sop = (~a) & (~b) & c & (~d);
  wire term2_sop = b & c & d;
  assign out_sop = term1_sop | term2_sop;

  // Minimal POS: out_pos = (a + b + d)(a + c + d)(a' + b + c' + d')
  wire term1_pos = a | b | d;
  wire term2_pos = a | c | d;
  wire term3_pos = (~a) | b | (~c) | (~d);
  assign out_pos = term1_pos & term2_pos & term3_pos;

endmodule