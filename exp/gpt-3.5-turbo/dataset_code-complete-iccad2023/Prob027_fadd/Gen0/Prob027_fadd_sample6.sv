module HalfAdder (
  input a,
  input b,
  output sum,
  output carry
);

  assign {sum, carry} = a + b;

endmodule

module FullAdder (
  input a,
  input b,
  input cin,
  output sum,
  output cout
);

  wire ps, co1;

  HalfAdder HA1(a, b, ps, co1);
  HalfAdder HA2(ps, cin, sum, co2);

  assign cout = co1 | co2;

endmodule

module TopModule (
  input a,
  input b,
  input cin,
  output cout,
  output sum
);

  FullAdder FA(a, b, cin, sum, cout);

endmodule