// Half Adder module
module HalfAdder(
    input   logic a,
    input   logic b,
    output  logic sum,
    output  logic cout
);

    assign sum = a ^ b;
    assign cout = a & b;

endmodule

// 4-Bit Adder module using Half Adders and Multiplexer-Based Carry Selection
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    wire logic [3:0] carry;
    wire logic [3:0] sum_temp;

    // Half Adder for bit 0
    HalfAdder ha0(
        .a(x[0]),
        .b(y[0]),
        .sum(sum_temp[0]),
        .cout(carry[0])
    );

    // Half Adder for bit 1
    HalfAdder ha1(
        .a(x[1]),
        .b(y[1]),
        .sum(sum_temp[1]),
        .cout(carry[1])
    );

    // Half Adder for bit 2
    HalfAdder ha2(
        .a(x[2]),
        .b(y[2]),
        .sum(sum_temp[2]),
        .cout(carry[2])
    );

    // Half Adder for bit 3
    HalfAdder ha3(
        .a(x[3]),
        .b(y[3]),
        .sum(sum_temp[3]),
        .cout(carry[3])
    );

    // Multiplexer-Based Carry Selection
    assign sum[0] = sum_temp[0];
    assign sum[1] = sum_temp[1] ^ carry[0];
    assign sum[2] = sum_temp[2] ^ carry[1];
    assign sum[3] = sum_temp[3] ^ carry[2];
    assign sum[4] = carry[3];

endmodule