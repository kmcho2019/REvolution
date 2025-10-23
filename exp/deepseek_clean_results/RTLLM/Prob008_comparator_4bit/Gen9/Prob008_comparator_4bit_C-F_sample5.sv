module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality (most power efficient)
    wire equal = &(A ~^ B);
    
    // Parallel comparison terms
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_lt = ~A & B;
    
    // Balanced tree comparison (2 levels for 4-bit)
    // Level 1: Compare bit pairs
    wire gt_10 = bit_gt[1] | (A[1] == B[1] & bit_gt[0]);
    wire lt_10 = bit_lt[1] | (A[1] == B[1] & bit_lt[0]);
    wire gt_32 = bit_gt[3] | (A[3] == B[3] & bit_gt[2]);
    wire lt_32 = bit_lt[3] | (A[3] == B[3] & bit_lt[2]);
    
    // Level 2: Combine results
    wire greater = gt_32 | (A[3] == B[3] & gt_10);
    wire less = lt_32 | (A[3] == B[3] & lt_10);
    
    // Final outputs (mutually exclusive)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & less;

endmodule