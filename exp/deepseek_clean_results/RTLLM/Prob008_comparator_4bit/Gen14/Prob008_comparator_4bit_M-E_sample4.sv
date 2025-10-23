module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals
    wire [3:0] bit_eq = ~(A ^ B);
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_lt = ~A & B;

    // First level prefix computation (bit pairs)
    wire eq_10 = bit_eq[1] & bit_eq[0];
    wire gt_10 = bit_gt[1] | (bit_eq[1] & bit_gt[0]);
    wire lt_10 = bit_lt[1] | (bit_eq[1] & bit_lt[0]);

    wire eq_32 = bit_eq[3] & bit_eq[2];
    wire gt_32 = bit_gt[3] | (bit_eq[3] & bit_gt[2]);
    wire lt_32 = bit_lt[3] | (bit_eq[3] & bit_lt[2]);

    // Second level prefix computation (final results)
    wire equal = eq_32 & eq_10;
    wire greater = gt_32 | (eq_32 & gt_10);
    wire less = lt_32 | (eq_32 & lt_10);

    // Output assignments
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = less;

endmodule