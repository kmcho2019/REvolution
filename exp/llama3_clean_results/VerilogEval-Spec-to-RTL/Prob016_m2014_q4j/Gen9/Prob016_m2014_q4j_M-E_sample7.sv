// Define the HalfAdder module
module HalfAdder(
    input   a,
    input   b,
    output  sum,
    output  cout
);

    assign sum = a ^ b;
    assign cout = a & b;

endmodule

// Define the FullAdder module using two HalfAdders
module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

    wire sum1, cout1;

    HalfAdder ha1(
        .a(a),
        .b(b),
        .sum(sum1),
        .cout(cout1)
    );

    HalfAdder ha2(
        .a(sum1),
        .b(cin),
        .sum(sum),
        .cout(cout)
    );

    // OR the carry-outs from both half adders
    assign cout = cout1 | (sum1 & cin);

endmodule

// Define the 2-bit adder module
module TwoBitAdder(
    input   [1:0] x,
    input   [1:0] y,
    output  [1:0] sum,
    output  cout
);

    wire sum1, cout1;

    HalfAdder ha1(
        .a(x[0]),
        .b(y[0]),
        .sum(sum[0]),
        .cout(cout1)
    );

    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(cout1),
        .sum(sum[1]),
        .cout(cout)
    );

endmodule

// Define the TopModule
module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [1:0] sum_low, sum_high;
    wire cout_low, cout_high;

    TwoBitAdder tba1(
        .x(x[1:0]),
        .y(y[1:0]),
        .sum(sum_low),
        .cout(cout_low)
    );

    TwoBitAdder tba2(
        .x({x[3:2], 1'b0}),
        .y({y[3:2], cout_low}),
        .sum(sum_high),
        .cout(cout_high)
    );

    assign sum[3:0] = {sum_high[1], sum_low};
    assign sum[4] = cout_high;

endmodule