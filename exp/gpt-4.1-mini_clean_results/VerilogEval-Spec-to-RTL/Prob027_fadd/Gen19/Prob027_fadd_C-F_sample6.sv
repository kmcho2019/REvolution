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
    wire s1, c1, c2;

    // Instantiate first half adder: sum of a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(s1),
        .carry(c1)
    );

    // Instantiate second half adder: sum of s1 and cin
    HalfAdder ha2 (
        .x(s1),
        .y(cin),
        .sum(sum),
        .carry(c2)
    );

    // Carry out is OR of intermediate carries
    assign cout = c1 | c2;
endmodule