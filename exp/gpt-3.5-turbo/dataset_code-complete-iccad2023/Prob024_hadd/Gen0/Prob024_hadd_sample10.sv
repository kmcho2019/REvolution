module HalfAdder (
  input a,
  input b,
  output sum,
  output cout
);

  // Calculate sum
  assign sum = a ^ b;

  // Calculate carry-out
  assign cout = a & b;

endmodule