module TopModule (
  input a,
  input b,
  output sum,
  output cout
);
  assign sum = a ^ b;    // sum is a XOR b
  assign cout = a & b;   // carry is a AND b
endmodule