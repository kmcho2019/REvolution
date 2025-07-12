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
    wire sum1, carry1, carry2;

    // First half adder adds a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(sum1),
        .carry(carry1)
    );

    // Second half adder adds the intermediate sum and cin
    HalfAdder ha2 (
        .x(sum1),
        .y(cin),
        .sum(sum),
        .carry(carry2)
    );

    // Final carry-out is the OR of the two half adder carries
    assign cout = carry1 | carry2;
endmodule