module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Direct arithmetic comparison for 3-bit case (optimal for this width)
    assign A_greater = (A > B);
    
    // Most efficient equality check (arithmetic)
    assign A_equal = (A == B);
    
    // Optimized derived output (most direct implementation)
    assign A_less = ~(A_greater | A_equal);

endmodule