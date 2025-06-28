module FullAdder (
  input a,
  input b,
  input cin,
  output cout,
  output sum
);

  // First half adder
  wire ha_carry;
  wire ha_sum;
  
  HalfAdder ha1(
    .a(a),
    .b(b),
    .sum(ha_sum),
    .carry(ha_carry)
  );

  // Second half adder
  HalfAdder ha2(
    .a(ha_sum),
    .b(cin),
    .sum(sum),
    .carry(cout)
  );

endmodule

module HalfAdder (
  input a,
  input b,
  output sum,
  output carry
);

  assign sum = a ^ b;
  assign carry = a & b;

endmodule