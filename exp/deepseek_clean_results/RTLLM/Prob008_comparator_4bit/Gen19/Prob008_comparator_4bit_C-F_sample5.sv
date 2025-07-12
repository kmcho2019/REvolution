module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Power-optimized bitwise comparison
    wire [3:0] bit_eq = A ~^ B;  // XNOR for lower power
    wire [3:0] bit_gt = A & ~B;  // Direct greater detection

    // Fast parallel equality check
    wire equal = &bit_eq;

    // Optimized hierarchical greater detection with shared terms
    wire eq_high3 = bit_eq[3];
    wire eq_high2 = eq_high3 & bit_eq[2];
    wire eq_high1 = eq_high2 & bit_eq[1];
    
    wire greater = bit_gt[3] | 
                  (eq_high3 & bit_gt[2]) | 
                  (eq_high2 & bit_gt[1]) | 
                  (eq_high1 & bit_gt[0]);

    // Output logic with guaranteed mutual exclusivity
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule