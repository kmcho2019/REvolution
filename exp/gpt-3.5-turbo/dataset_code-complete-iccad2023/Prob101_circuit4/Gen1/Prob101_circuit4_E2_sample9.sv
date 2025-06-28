module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

  assign q = (a & b) | (a & c) | (a & d) | (b & c) | (b & d) | (c & d) | (a & b & c) | (a & b & d) | (a & c & d) | (b & c & d);

endmodule