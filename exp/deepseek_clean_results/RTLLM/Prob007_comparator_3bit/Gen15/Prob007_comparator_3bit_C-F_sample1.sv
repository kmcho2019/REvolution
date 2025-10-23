module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Shared bit equality terms (power optimization)
    wire [2:0] bit_eq = ~(A ^ B);

    // Hierarchical magnitude comparison with early termination
    wire gt_msb = A[2] & ~B[2];
    wire eq_msb = bit_eq[2];
    
    wire gt_mid = eq_msb & (A[1] & ~B[1]);
    wire eq_mid = eq_msb & bit_eq[1];
    
    wire gt_lsb = eq_mid & (A[0] & ~B[0]);

    // Most efficient equality check (arithmetic)
    assign A_equal = (A == B);

    // Combined greater-than signal
    assign A_greater = gt_msb | gt_mid | gt_lsb;

    // Optimized derived output (better PPA)
    assign A_less = ~A_greater & ~A_equal;

endmodule