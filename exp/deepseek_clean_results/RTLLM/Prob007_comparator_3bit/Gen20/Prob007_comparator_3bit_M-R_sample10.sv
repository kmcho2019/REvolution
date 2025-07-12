module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // MSB comparison (highest priority)
    wire msb_greater = A[2] & ~B[2];
    wire msb_equal = ~(A[2] ^ B[2]);
    
    // Middle bit comparison
    wire mid_greater = A[1] & ~B[1];
    wire mid_equal = ~(A[1] ^ B[1]);
    
    // LSB comparison
    wire lsb_greater = A[0] & ~B[0];
    
    // Hierarchical comparison
    assign A_greater = msb_greater | 
                      (msb_equal & mid_greater) | 
                      (msb_equal & mid_equal & lsb_greater);

    // Arithmetic equality check
    assign A_equal = (A == B);

    // Derived less than output
    assign A_less = ~A_greater & ~A_equal;

endmodule