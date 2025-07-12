module HalfAdder (
    input  x,
    input  y,
    output sum,
    output carry
);
    assign sum = x ^ y;
    assign carry = x & y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire carry1, carry2;
    wire sum1;

    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(sum1),
        .carry(carry1)
    );

    HalfAdder ha2 (
        .x(sum1),
        .y(cin),
        .sum(sum),
        .carry(carry2)
    );

    assign cout = carry1 | carry2;
endmodule