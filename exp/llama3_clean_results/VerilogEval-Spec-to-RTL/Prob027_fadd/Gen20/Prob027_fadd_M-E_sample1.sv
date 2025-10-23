// Half Adder Module
module HalfAdder(
    input a,
    input b,
    output sum,
    output cout
);

assign sum = a ^ b; // XOR gate for sum calculation
assign cout = a & b; // AND gate for carry-out calculation

endmodule

// Full Adder Module
module FullAdder(
    input a,
    input b,
    input cin,
    output reg cout,
    output reg sum
);

wire half_sum;
wire half_cout;

HalfAdder ha1(
    .a(a),
    .b(b),
    .sum(half_sum),
    .cout(half_cout)
);

HalfAdder ha2(
    .a(half_sum),
    .b(cin),
    .sum(sum),
    .cout(cout)
);

endmodule

// Top Module
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

FullAdder fa(
    .a(a),
    .b(b),
    .cin(cin),
    .cout(cout),
    .sum(sum)
);

endmodule