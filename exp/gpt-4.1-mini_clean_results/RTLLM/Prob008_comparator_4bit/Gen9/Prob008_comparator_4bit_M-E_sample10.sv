module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // 1-bit comparator module declaration (internal)
    // Inputs: a_bit, b_bit, prev_greater, prev_equal, prev_less
    // Outputs: greater, equal, less reflecting comparison from MSB down to this bit
    module comparator_1bit (
        input  a_bit,
        input  b_bit,
        input  prev_greater,
        input  prev_equal,
        input  prev_less,
        output greater,
        output equal,
        output less
    );
        wire bit_gt = a_bit & ~b_bit;
        wire bit_lt = ~a_bit & b_bit;
        wire bit_eq = ~(bit_gt | bit_lt);

        assign greater = prev_greater | (prev_equal & bit_gt);
        assign less    = prev_less    | (prev_equal & bit_lt);
        assign equal   = prev_equal   & bit_eq;
    endmodule

    // Instantiate 4 cascaded 1-bit comparators from MSB (bit 3) down to LSB (bit 0)

    wire g3, e3, l3;
    comparator_1bit comp3 (
        .a_bit(A[3]),
        .b_bit(B[3]),
        .prev_greater(1'b0), // MSB level: no previous greater
        .prev_equal(1'b1),   // Initially assume equal
        .prev_less(1'b0),
        .greater(g3),
        .equal(e3),
        .less(l3)
    );

    wire g2, e2, l2;
    comparator_1bit comp2 (
        .a_bit(A[2]),
        .b_bit(B[2]),
        .prev_greater(g3),
        .prev_equal(e3),
        .prev_less(l3),
        .greater(g2),
        .equal(e2),
        .less(l2)
    );

    wire g1, e1, l1;
    comparator_1bit comp1 (
        .a_bit(A[1]),
        .b_bit(B[1]),
        .prev_greater(g2),
        .prev_equal(e2),
        .prev_less(l2),
        .greater(g1),
        .equal(e1),
        .less(l1)
    );

    wire g0, e0, l0;
    comparator_1bit comp0 (
        .a_bit(A[0]),
        .b_bit(B[0]),
        .prev_greater(g1),
        .prev_equal(e1),
        .prev_less(l1),
        .greater(g0),
        .equal(e0),
        .less(l0)
    );

    // Final outputs are from LSB comparator outputs because it aggregates all bits
    assign A_greater = g0;
    assign A_equal   = e0;
    assign A_less    = l0;

endmodule