module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);
  
  assign q = (c == d) ? 1 : 0;

endmodule