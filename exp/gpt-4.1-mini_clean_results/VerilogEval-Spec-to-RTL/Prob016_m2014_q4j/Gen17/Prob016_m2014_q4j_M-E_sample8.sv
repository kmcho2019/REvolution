module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire axb = a ^ b;
    assign sum  = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

module Ripple2BitAdder(
    input  [1:0] a,
    input  [1:0] b,
    input        cin,
    output [1:0] sum,
    output       cout
);
    wire c1;
    FullAdder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c1)
    );
    FullAdder fa1 (
        .a(a[1]),
        .b(b[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(cout)
    );
endmodule

module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [1:0] sum_low, sum_high;
    wire carry_low, carry_high, carry_final;

    // Add lower two bits
    Ripple2BitAdder adder_low (
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(carry_low)
    );

    // Add upper two bits
    Ripple2BitAdder adder_high (
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(sum_high),
        .cout(carry_high)
    );

    // Add the carry-outs of low and high 2-bit adders to form final carry chain
    FullAdder carry_adder (
        .a(carry_low),
        .b(carry_high),
        .cin(1'b0),
        .sum(sum[4]),
        .cout() // Overflow bit is sum[4], so no further carry
    );

    assign sum[1:0] = sum_low;
    assign sum[3:2] = sum_high;
endmodule