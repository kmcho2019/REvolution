module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);
  // q is 1 if the number of 1's in a,b,c,d is even (even parity)
  assign q = ~(a ^ b ^ c ^ d);
endmodule