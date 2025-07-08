module TopModule (
  input a,
  input b,
  input c,
  input d,
  output q
);
  assign q = ~(a ^ b ^ c ^ d); // Even parity: output 1 if even number of 1's
endmodule