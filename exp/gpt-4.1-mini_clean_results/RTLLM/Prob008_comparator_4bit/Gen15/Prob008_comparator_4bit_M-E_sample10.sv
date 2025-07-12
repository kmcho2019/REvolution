module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal signals to connect cascaded comparators
    wire g3, e3, l3;
    wire g2, e2, l2;
    wire g1, e1, l1;
    wire g0, e0, l0;

    // Start from MSB: no incoming info, so initial values
    // For MSB comparator, incoming signals are:
    // A_greater_in = 0, A_equal_in = 1, A_less_in = 0 (assume equality prior to MSB)
    comparator_1bit comp3 (
        .A_bit(A[3]),
        .B_bit(B[3]),
        .A_greater_in(1'b0),
        .A_equal_in(1'b1),
        .A_less_in(1'b0),
        .A_greater_out(g3),
        .A_equal_out(e3),
        .A_less_out(l3)
    );

    comparator_1bit comp2 (
        .A_bit(A[2]),
        .B_bit(B[2]),
        .A_greater_in(g3),
        .A_equal_in(e3),
        .A_less_in(l3),
        .A_greater_out(g2),
        .A_equal_out(e2),
        .A_less_out(l2)
    );

    comparator_1bit comp1 (
        .A_bit(A[1]),
        .B_bit(B[1]),
        .A_greater_in(g2),
        .A_equal_in(e2),
        .A_less_in(l2),
        .A_greater_out(g1),
        .A_equal_out(e1),
        .A_less_out(l1)
    );

    comparator_1bit comp0 (
        .A_bit(A[0]),
        .B_bit(B[0]),
        .A_greater_in(g1),
        .A_equal_in(e1),
        .A_less_in(l1),
        .A_greater_out(g0),
        .A_equal_out(e0),
        .A_less_out(l0)
    );

    // Final outputs are from LSB comparator outputs
    assign A_greater = g0;
    assign A_equal   = e0;
    assign A_less    = l0;

endmodule

// 1-bit comparator module: compares A_bit and B_bit, plus incoming comparison
module comparator_1bit (
    input  A_bit,
    input  B_bit,
    input  A_greater_in,
    input  A_equal_in,
    input  A_less_in,
    output A_greater_out,
    output A_equal_out,
    output A_less_out
);

    // If bits differ, this bit decides the output.
    // Otherwise, propagate incoming signals.
    wire bit_greater = A_bit & ~B_bit;
    wire bit_less    = ~A_bit & B_bit;
    wire bit_equal   = ~(bit_greater | bit_less); // A_bit == B_bit

    assign A_greater_out = bit_greater | (bit_equal & A_greater_in);
    assign A_less_out    = bit_less    | (bit_equal & A_less_in);
    assign A_equal_out   = bit_equal   & A_equal_in;

endmodule