module HalfAdder(
  input a,
  input b,
  output sum,
  output carry
);

  assign sum = a ^ b;
  assign carry = a & b;

endmodule

module FullAdder(
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  wire ha_carry1;
  wire ha_sum1;
  wire ha_sum2;
  wire ha_carry2;

  HalfAdder HA1(a, b, ha_sum1, ha_carry1);
  HalfAdder HA2(ha_sum1, cin, ha_sum2, ha_carry2);
  
  assign sum = ha_sum2;
  assign cout = ha_carry1 | ha_carry2;

endmodule