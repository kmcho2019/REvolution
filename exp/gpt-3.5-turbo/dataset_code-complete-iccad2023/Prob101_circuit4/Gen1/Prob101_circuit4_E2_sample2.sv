module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

assign q = d | ((b & c) | (b & a) | (c & a));

endmodule