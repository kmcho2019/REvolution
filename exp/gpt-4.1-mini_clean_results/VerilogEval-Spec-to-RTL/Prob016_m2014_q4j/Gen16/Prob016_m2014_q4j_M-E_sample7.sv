module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TwoBitAdder (
    input  [1:0] a,
    input  [1:0] b,
    input        cin,
    output [1:0] sum,
    output       cout
);
    wire c1;

    // First full adder: least significant bit
    FullAdder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c1)
    );

    // Second full adder: most significant bit of 2-bit block
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
    wire [1:0] sum_low, sum_high;
    wire c_low, c_high;

    // Lower 2 bits addition with carry-in 0
    TwoBitAdder lower_adder (
        .a(x[1:0]),
        .b(y[1:0]),
        .cin(1'b0),
        .sum(sum_low),
        .cout(c_low)
    );

    // Upper 2 bits addition with carry-in from lower 2 bits
    TwoBitAdder upper_adder (
        .a(x[3:2]),
        .b(y[3:2]),
        .cin(c_low),
        .sum(sum_high),
        .cout(c_high)
    );

    // Combine sums and carry out as the 5th bit
    assign sum = {c_high, sum_high, sum_low};
endmodule