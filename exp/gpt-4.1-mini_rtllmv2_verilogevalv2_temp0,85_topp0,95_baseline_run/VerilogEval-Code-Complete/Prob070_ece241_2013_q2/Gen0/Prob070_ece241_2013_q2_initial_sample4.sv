module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // SOP expression: a' b' c + a c d
  assign out_sop = (~a & ~b & c) | (a & c & d);

  // POS expression: (a + b + d') (b + c' + d')
  assign out_pos = (a | b | ~d) & (b | ~c | ~d);

endmodule