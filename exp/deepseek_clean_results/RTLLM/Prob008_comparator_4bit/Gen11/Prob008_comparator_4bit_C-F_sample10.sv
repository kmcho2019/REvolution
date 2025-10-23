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

    // Parallel equality check (fastest path)
    wire equal = &bit_eq;

    // Optimized hierarchical greater detection
    wire greater = bit_gt[3] | 
                  (bit_eq[3] & bit_gt[2]) | 
                  (bit_eq[3] & bit_eq[2] & bit_gt[1]) | 
                  (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);

    // Output logic with mutual exclusivity
    assign A_equal = equal;
    assign A_greater = greater & ~equal;  // Prevent overlap
    assign A_less = ~equal & ~greater;    // Derived from others

endmodule