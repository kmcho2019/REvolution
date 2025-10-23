module HalfAdder(
    input   a,
    input   b,
    output  sum,
    output  carry
);

    assign sum = a ^ b;
    assign carry = a & b;

endmodule

module TreeAdder(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [1:0] sum_0, sum_1, sum_2, sum_3;
    wire [1:0] carry_0, carry_1, carry_2;

    HalfAdder ha0(
        .a(x[0]),
        .b(y[0]),
        .sum(sum_0[0]),
        .carry(carry_0[0])
    );

    HalfAdder ha1(
        .a(x[1]),
        .b(y[1]),
        .sum(sum_1[0]),
        .carry(carry_1[0])
    );

    HalfAdder ha2(
        .a(x[2]),
        .b(y[2]),
        .sum(sum_2[0]),
        .carry(carry_2[0])
    );

    HalfAdder ha3(
        .a(x[3]),
        .b(y[3]),
        .sum(sum_3[0]),
        .carry(carry_0[1])
    );

    HalfAdder ha4(
        .a(sum_0[0]),
        .b(sum_1[0]),
        .sum(sum_0[1]),
        .carry(carry_1[1])
    );

    HalfAdder ha5(
        .a(sum_2[0]),
        .b(sum_3[0]),
        .sum(sum_1[1]),
        .carry(carry_2[1])
    );

    HalfAdder ha6(
        .a(sum_0[1]),
        .b(sum_1[1]),
        .sum(sum[3]),
        .carry(sum[4])
    );

    assign sum[0] = sum_0[0];
    assign sum[1] = sum_1[0];
    assign sum[2] = sum_2[0];

endmodule