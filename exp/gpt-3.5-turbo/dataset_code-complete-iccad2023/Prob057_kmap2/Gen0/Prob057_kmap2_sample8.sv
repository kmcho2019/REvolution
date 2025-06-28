module TopModule (
  input a,
  input b,
  input c,
  input d,
  output out
);

assign out = (a & b & ~c) | (a & c & d) | (a & b & d) | (~b & c & ~d);

endmodule