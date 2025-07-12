module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Fast parallel equality check
    wire equal = (A == B);
    
    // Shared bit-wise comparison signals
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_eq = ~(A ^ B);
    
    // Optimized hierarchical comparison
    wire gt_hi = bit_gt[3] | 
                (bit_eq[3] & bit_gt[2]) |
                (bit_eq[3] & bit_eq[2] & bit_gt[1]) |
                (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);
    
    // Output assignments - mutually exclusive by construction
    assign A_equal = equal;
    assign A_greater = ~equal & gt_hi;
    assign A_less = ~equal & ~gt_hi;

endmodule