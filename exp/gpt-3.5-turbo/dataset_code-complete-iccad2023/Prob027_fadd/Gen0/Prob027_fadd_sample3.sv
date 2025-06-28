module half_adder (
  input a,
  input b,
  output sum,
  output cout
);
  assign sum = a ^ b;
  assign cout = a & b;
endmodule

module full_adder (
  input a,
  input b,
  input cin,
  output sum,
  output cout
);
  wire s1, c1, c2;
  half_adder HA1(.a(a), .b(b), .sum(s1), .cout(c1));
  half_adder HA2(.a(s1), .b(cin), .sum(sum), .cout(c2));
  assign cout = c1 | c2;
endmodule

module TopModule (
  input a,
  input b,
  input cin,
  output cout,
  output sum
);
  full_adder FA(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));
endmodule