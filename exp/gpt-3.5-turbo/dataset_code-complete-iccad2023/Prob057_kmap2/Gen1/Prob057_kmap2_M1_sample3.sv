module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

assign out = (~a & b & c) | (a & ~d) | (b & ~c) | (c & d);

endmodule