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
  output cout,
  output sum
);

  wire ha1_sum, ha1_carry, ha2_sum, ha2_carry;

  HalfAdder HA1(a, b, ha1_sum, ha1_carry);
  HalfAdder HA2(ha1_sum, cin, sum, ha2_carry);

  assign cout = ha1_carry | ha2_carry;

endmodule