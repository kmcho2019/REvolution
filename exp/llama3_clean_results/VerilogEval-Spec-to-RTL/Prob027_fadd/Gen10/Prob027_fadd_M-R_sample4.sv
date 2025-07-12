module HalfAdder(
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b;
assign cout = a & b;

endmodule

module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

wire ha1_sum;
wire ha1_cout;

HalfAdder ha1(
   .a(a),
   .b(b),
   .sum(ha1_sum),
   .cout(ha1_cout)
);

HalfAdder ha2(
   .a(ha1_sum),
   .b(cin),
   .sum(sum),
   .cout(cout)
);

assign cout = ha1_cout | ha2.cout;

endmodule