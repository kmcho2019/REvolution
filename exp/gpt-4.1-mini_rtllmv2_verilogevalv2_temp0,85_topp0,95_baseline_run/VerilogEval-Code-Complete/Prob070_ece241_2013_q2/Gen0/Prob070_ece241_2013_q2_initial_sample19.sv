module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out_sop,
  output out_pos
);

  // Minimal sum of products form:
  // out_sop = a & d | b & ~c & d
  assign out_sop = (a & d) | (b & ~c & d);

  // Minimal product of sums form:
  // out_pos = (a + b + ~d) & (~a + c + d)
  assign out_pos = (a | b | ~d) & (~a | c | d);

endmodule