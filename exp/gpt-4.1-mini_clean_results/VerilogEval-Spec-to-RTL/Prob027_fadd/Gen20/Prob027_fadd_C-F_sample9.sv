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

    // First half adder: sum of a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(s1),
        .carry(c1)
    );

    // Second half adder: sum of s1 and cin
    HalfAdder ha2 (
        .x(s1),
        .y(cin),
        .sum(sum),
        .carry(c2)
    );

    // Carry-out is majority of a,b,cin
    // Equivalently, cout = c1 | c2
    // But to optimize for power and performance, directly implement majority function:
    // cout = (a&b) | (b&cin) | (a&cin)
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule