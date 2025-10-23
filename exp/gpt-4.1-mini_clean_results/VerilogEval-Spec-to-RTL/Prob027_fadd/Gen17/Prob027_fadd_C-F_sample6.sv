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

    // First half adder adds a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(sum),
        .carry(carry1)
    );

    // Second half adder adds sum from ha1 and cin
    HalfAdder ha2 (
        .x(sum),
        .y(cin),
        .sum(sum),
        .carry(carry2)
    );

    // Final carry-out is the OR of two carries from half adders
    assign cout = carry1 | carry2;
endmodule