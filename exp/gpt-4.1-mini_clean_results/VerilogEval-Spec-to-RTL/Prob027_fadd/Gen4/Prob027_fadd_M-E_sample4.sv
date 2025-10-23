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
    wire sum1, cout1, cout2;

    // First half adder: adds a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(sum1),
        .cout(cout1)
    );

    // Second half adder: adds sum1 and cin
    HalfAdder ha2 (
        .x(sum1),
        .y(cin),
        .sum(sum),
        .cout(cout2)
    );

    // Carry out is OR of carry outputs from both half adders
    assign cout = cout1 | cout2;

endmodule