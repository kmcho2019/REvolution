module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

  assign out = (~a & ~d) | (c & d) | (~a & b) | (a & ~b & ~c) | (~a & ~b & d);

endmodule