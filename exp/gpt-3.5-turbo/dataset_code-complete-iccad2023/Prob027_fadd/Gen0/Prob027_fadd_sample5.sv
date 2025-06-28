module HalfAdder (
  input a,
  input b,
  output sum,
  output carry
);

  assign sum = a ^ b;
  assign carry = a & b;

endmodule

module FullAdder (
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  wire s1, c1, s2;
  HalfAdder HA1(a, b, s1, c1);
  HalfAdder HA2(s1, cin, sum, c2);

  assign cout = c1 | c2;

endmodule