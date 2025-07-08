module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);
  assign q = (b + c + d) >= 2;
endmodule