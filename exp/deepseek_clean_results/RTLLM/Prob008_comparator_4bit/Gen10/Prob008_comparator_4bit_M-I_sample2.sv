module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Combined comparison logic
    wire [3:0] bit_eq = ~(A ^ B);
    wire [3:0] bit_gt = A & ~B;
    
    // Hierarchical comparison with priority encoding
    wire greater = bit_gt[3] | 
                  (bit_eq[3] & bit_gt[2]) | 
                  (bit_eq[3] & bit_eq[2] & bit_gt[1]) | 
                  (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);

    // Final outputs
    assign A_equal = &bit_eq;  // All bits equal
    assign A_greater = greater & ~A_equal;
    assign A_less = ~(A_equal | greater);  // Derived from other outputs

endmodule