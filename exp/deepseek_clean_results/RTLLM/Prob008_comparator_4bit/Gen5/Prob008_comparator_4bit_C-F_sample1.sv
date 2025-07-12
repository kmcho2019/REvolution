module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Combined equality and magnitude comparison
    wire equal = (A == B);
    wire [3:0] bit_greater = A & ~B;
    wire [3:0] bit_equal = ~(A ^ B);
    
    // Optimized hierarchical comparison with early termination
    wire greater = bit_greater[3] |
                 (bit_equal[3] & bit_greater[2]) |
                 (bit_equal[3] & bit_equal[2] & bit_greater[1]) |
                 (bit_equal[3] & bit_equal[2] & bit_equal[1] & bit_greater[0]);

    // Output assignments (mutually exclusive by construction)
    assign A_equal = equal;
    assign A_greater = ~equal & greater;
    assign A_less = ~equal & ~greater;

endmodule