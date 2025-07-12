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
    wire sum_ab, carry_ab;

    // Use one half adder to add a and b
    HalfAdder ha (
        .x(a),
        .y(b),
        .sum(sum_ab),
        .carry(carry_ab)
    );

    // Final sum is XOR of sum_ab and cin
    assign sum = sum_ab ^ cin;

    // Carry out is carry_ab OR (cin AND sum_ab)
    assign cout = carry_ab | (cin & sum_ab);
endmodule