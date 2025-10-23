module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Shared intermediate terms
    wire [3:0] bit_eq = ~(A ^ B);  // XNOR for equality
    wire [3:0] bit_gt = A & ~B;
    
    // Early termination signals
    wire cmp_3 = bit_gt[3] | (~bit_eq[3]);
    wire cmp_2 = bit_gt[2] | (~bit_eq[2]);
    wire cmp_1 = bit_gt[1] | (~bit_eq[1]);
    
    // Hierarchical comparison with early termination
    wire gt_hi = bit_gt[3] | 
                (bit_eq[3] & cmp_2) |
                (bit_eq[3] & bit_eq[2] & cmp_1) |
                (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);
    
    // Final outputs
    wire equal = &bit_eq;  // AND reduction of equality bits
    wire greater = ~equal & gt_hi;
    
    assign A_equal = equal;
    assign A_greater = greater;
    assign A_less = ~equal & ~greater;

endmodule