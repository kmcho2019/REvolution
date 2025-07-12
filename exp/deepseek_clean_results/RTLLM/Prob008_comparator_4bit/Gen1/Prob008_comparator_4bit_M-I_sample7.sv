module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality comparison
    wire [3:0] bit_eq;
    assign bit_eq = A ~^ B;  // XNOR for bit equality
    
    // Full equality (AND reduction)
    assign A_equal = &bit_eq;

    // Hierarchical greater/less comparison
    wire A_gt_B3, A_lt_B3;
    wire A_gt_B2, A_lt_B2;
    wire A_gt_B1, A_lt_B1;
    wire A_gt_B0, A_lt_B0;

    // MSB (bit 3) comparison
    assign A_gt_B3 = (A[3] & ~B[3]);
    assign A_lt_B3 = (~A[3] & B[3]);

    // bit 2 comparison (only if higher bits equal)
    assign A_gt_B2 = (A[2] & ~B[2]) & bit_eq[3];
    assign A_lt_B2 = (~A[2] & B[2]) & bit_eq[3];

    // bit 1 comparison (only if higher bits equal)
    assign A_gt_B1 = (A[1] & ~B[1]) & (&bit_eq[3:2]);
    assign A_lt_B1 = (~A[1] & B[1]) & (&bit_eq[3:2]);

    // LSB (bit 0) comparison (only if higher bits equal)
    assign A_gt_B0 = (A[0] & ~B[0]) & (&bit_eq[3:1]);
    assign A_lt_B0 = (~A[0] & B[0]) & (&bit_eq[3:1]);

    // Combine all comparison results
    assign A_greater = A_gt_B3 | A_gt_B2 | A_gt_B1 | A_gt_B0;
    assign A_less = A_lt_B3 | A_lt_B2 | A_lt_B1 | A_lt_B0;

endmodule