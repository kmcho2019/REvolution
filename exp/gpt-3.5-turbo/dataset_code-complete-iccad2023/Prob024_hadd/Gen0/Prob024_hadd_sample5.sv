module HalfAdder (
  input a,
  input b,
  output sum,
  output cout
);
  assign sum = a ^ b;
  assign cout = a & b;
endmodule

module TopModule (
  input a,
  input b,
  output sum,
  output cout
);
  HalfAdder ha1(
    .a(a),
    .b(b),
    .sum(sum),
    .cout(cout)
  );
endmodule