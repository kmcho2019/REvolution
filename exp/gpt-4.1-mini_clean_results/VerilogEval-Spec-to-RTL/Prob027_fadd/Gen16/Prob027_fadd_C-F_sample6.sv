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

    // One half adder: adds a and b
    HalfAdder ha_ab (
        .x(a),
        .y(b),
        .sum(sum_ab),
        .cout(carry_ab)
    );

    // Final sum: sum_ab XOR cin
    assign sum = sum_ab ^ cin;

    // Final carry out: carry_ab OR (sum_ab AND cin)
    assign cout = carry_ab | (sum_ab & cin);

endmodule