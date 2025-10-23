module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    wire sum1, c1, c2;

    // First half adder: adds a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(sum1),
        .cout(c1)
    );

    // Second half adder: adds sum1 and cin
    HalfAdder ha2 (
        .x(sum1),
        .y(cin),
        .sum(sum),
        .cout(c2)
    );

    // OR the carries to get final carry out
    assign cout = c1 | c2;

endmodule

module HalfAdder (
    input  x,
    input  y,
    output sum,
    output cout
);
    assign sum = x ^ y;
    assign cout = x & y;
endmodule