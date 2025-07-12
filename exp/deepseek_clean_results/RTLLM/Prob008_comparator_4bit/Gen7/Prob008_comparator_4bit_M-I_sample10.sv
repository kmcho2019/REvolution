module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel equality check and bitwise comparisons
    wire [3:0] bit_eq = ~(A ^ B);
    wire [3:0] bit_gt = A & ~B;
    
    // Combined comparison flags
    wire gt3 = bit_gt[3];
    wire gt2 = bit_eq[3] & bit_gt[2];
    wire gt1 = bit_eq[3] & bit_eq[2] & bit_gt[1];
    wire gt0 = bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0];
    
    // Final magnitude comparison
    wire greater = gt3 | gt2 | gt1 | gt0;
    wire equal = &bit_eq;
    
    // Optimized output assignments
    assign A_equal = equal;
    assign A_greater = greater;  // mutually exclusive due to construction
    assign A_less = ~(equal | greater);

endmodule