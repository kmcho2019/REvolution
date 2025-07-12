module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals
    wire [3:0] bit_gt = A & ~B;  // A > B at each bit position
    wire [3:0] bit_eq = ~(A ^ B); // A == B at each bit position
    wire [3:0] bit_lt = ~A & B;  // A < B at each bit position

    // Prefix computation for greater-than
    wire gt_01 = bit_gt[1] | (bit_eq[1] & bit_gt[0]);
    wire gt_23 = bit_gt[3] | (bit_eq[3] & bit_gt[2]);
    wire gt_03 = gt_23 | (bit_eq[3] & bit_eq[2] & gt_01);

    // Prefix computation for less-than
    wire lt_01 = bit_lt[1] | (bit_eq[1] & bit_lt[0]);
    wire lt_23 = bit_lt[3] | (bit_eq[3] & bit_lt[2]);
    wire lt_03 = lt_23 | (bit_eq[3] & bit_eq[2] & lt_01);

    // Equal is simply all bit_eq signals ANDed
    wire equal = &bit_eq;

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & gt_03;
    assign A_less = ~equal & lt_03;

endmodule