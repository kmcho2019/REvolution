module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Local half adder module for encapsulation without instantiation overhead
    module HalfAdderLocal (
        input  x,
        input  y,
        output sum,
        output carry
    );
        assign sum = x ^ y;
        assign carry = x & y;
    endmodule

    wire sum1, carry1, carry2;

    // Instantiate local half adders
    HalfAdderLocal ha1 (
        .x(a),
        .y(b),
        .sum(sum1),
        .carry(carry1)
    );

    HalfAdderLocal ha2 (
        .x(sum1),
        .y(cin),
        .sum(sum),
        .carry(carry2)
    );

    assign cout = carry1 | carry2;

endmodule