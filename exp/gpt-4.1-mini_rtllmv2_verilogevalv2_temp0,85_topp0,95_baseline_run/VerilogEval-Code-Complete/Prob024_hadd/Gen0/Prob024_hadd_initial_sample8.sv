module TopModule (
  input a,
  input b,
  output sum,
  output cout
);
  assign sum = a ^ b;    // Sum = a XOR b
  assign cout = a & b;   // Carry-out = a AND b
endmodule