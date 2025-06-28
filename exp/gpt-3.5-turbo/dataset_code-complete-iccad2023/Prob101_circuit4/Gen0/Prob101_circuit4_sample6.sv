module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);

assign q = (d) | ((b | c) & ~a);

endmodule