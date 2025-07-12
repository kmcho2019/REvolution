module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Internal signals for bit-level comparisons
    wire a_gt_b_3, a_lt_b_3, a_eq_b_3;
    wire a_gt_b_2, a_lt_b_2, a_eq_b_2;
    wire a_gt_b_1, a_lt_b_1, a_eq_b_1;
    wire a_gt_b_0, a_lt_b_0, a_eq_b_0;

    // 1-bit comparators for each bit position
    assign a_gt_b_3 = A[3] & ~B[3];
    assign a_lt_b_3 = ~A[3] & B[3];
    assign a_eq_b_3 = A[3] == B[3];

    assign a_gt_b_2 = A[2] & ~B[2];
    assign a_lt_b_2 = ~A[2] & B[2];
    assign a_eq_b_2 = A[2] == B[2];

    assign a_gt_b_1 = A[1] & ~B[1];
    assign a_lt_b_1 = ~A[1] & B[1];
    assign a_eq_b_1 = A[1] == B[1];

    assign a_gt_b_0 = A[0] & ~B[0];
    assign a_lt_b_0 = ~A[0] & B[0];
    assign a_eq_b_0 = A[0] == B[0];

    // Cascaded comparison logic
    assign A_greater = a_gt_b_3 | (a_eq_b_3 & (a_gt_b_2 | (a_eq_b_2 & (a_gt_b_1 | (a_eq_b_1 & a_gt_b_0)))));
    assign A_equal   = a_eq_b_3 & a_eq_b_2 & a_eq_b_1 & a_eq_b_0;
    assign A_less    = a_lt_b_3 | (a_eq_b_3 & (a_lt_b_2 | (a_eq_b_2 & (a_lt_b_1 | (a_eq_b_1 & a_lt_b_0)))));

endmodule