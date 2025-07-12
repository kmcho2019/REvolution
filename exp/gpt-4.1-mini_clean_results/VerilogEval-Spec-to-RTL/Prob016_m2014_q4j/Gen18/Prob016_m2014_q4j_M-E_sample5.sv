module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    wire axb = a ^ b;
    assign sum = axb ^ cin;
    assign cout = (a & b) | (axb & cin);
endmodule

module RippleCarryAdder2 (
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

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [1:0] sum_lower;
    wire       carry_lower;

    // Lower 2 bits ripple-carry addition
    RippleCarryAdder2 lower_adder (
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_lower),
        .cout(carry_lower)
    );

    // Precompute upper sums and carries assuming carry_in = 0 and 1
    wire [1:0] sum_upper_c0, sum_upper_c1;
    wire       cout_upper_c0, cout_upper_c1;

    RippleCarryAdder2 upper_adder_c0 (
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b0),
        .sum(sum_upper_c0),
        .cout(cout_upper_c0)
    );

    RippleCarryAdder2 upper_adder_c1 (
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(1'b1),
        .sum(sum_upper_c1),
        .cout(cout_upper_c1)
    );

    // Multiplex upper sums and carry-out based on lower carry
    assign sum[1:0] = sum_lower;

    assign sum[3:2] = carry_lower ? sum_upper_c1 : sum_upper_c0;

    assign sum[4] = carry_lower ? cout_upper_c1 : cout_upper_c0;

endmodule