module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

assign out = (~b & ~d) | (~a & ~c) | (b & c & d) | (a & ~d);

endmodule