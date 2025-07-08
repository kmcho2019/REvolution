module TopModule (
  input a,
  input b,
  output sum,
  output cout
);
  assign sum = a ^ b;     // Sum is XOR of inputs
  assign cout = a & b;    // Carry-out is AND of inputs
endmodule