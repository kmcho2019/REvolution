module FullAdder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

FullAdder fa1(
   .a(a),
   .b(b),
   .cin(cin),
   .sum(sum),
   .cout(cout)
);

endmodule