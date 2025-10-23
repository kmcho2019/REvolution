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
    output carry
);
    assign sum = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule(
    input  [2:0] in,
    output [1:0] out
);
    wire sum1, c1;
    wire sum2, c2;

    // Add in[0] and in[1] with half adder
    HalfAdder ha0 (
        .a(in[0]),
        .b(in[1]),
        .sum(sum1),
        .carry(c1)
    );

    // Add sum1 and in[2] with full adder, carry-in = c1
    FullAdder fa0 (
        .a(sum1),
        .b(in[2]),
        .cin(c1),
        .sum(sum2),
        .carry(c2)
    );

    // The 2-bit population count is {carry_out, sum_out}
    assign out = {c2, sum2};
endmodule