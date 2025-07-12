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
    wire sum_ab, carry_ab;

    // First half adder: add a and b
    HalfAdder ha1 (
        .x(a),
        .y(b),
        .sum(sum_ab),
        .cout(carry_ab)
    );

    // Second half adder: add sum_ab and cin
    HalfAdder ha2 (
        .x(sum_ab),
        .y(cin),
        .sum(sum),
        .cout(cout)
    );

    // Combine carry outputs with OR gate done implicitly by assigning cout in second half adder
    // carry out is OR of carry_ab and cout from ha2
    assign cout = carry_ab | cout;

endmodule