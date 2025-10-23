module HalfAdder (
    input  x,
    input  y,
    output sum,
    output cout
);
    assign sum = x ^ y;
    assign cout = x & y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire s1, c1, c2;

    // First half adder: add a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(s1),
        .cout(c1)
    );

    // Second half adder: add sum of first HA and cin
    HalfAdder ha2 (
        .x(s1),
        .y(cin),
        .sum(sum),
        .cout(c2)
    );

    // Carry out is OR of the two half adder carries
    assign cout = c1 | c2;

endmodule