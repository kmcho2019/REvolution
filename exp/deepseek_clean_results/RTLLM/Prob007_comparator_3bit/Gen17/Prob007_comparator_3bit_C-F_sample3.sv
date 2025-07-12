module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Shared bit equality terms (power optimization)
    wire [2:0] bit_eq = ~(A ^ B);

    // MSB comparison (parallel evaluation)
    wire gt_msb = A[2] & ~B[2];
    wire eq_msb = bit_eq[2];

    // Mid-bit comparison (conditional on MSB equality)
    wire gt_mid = eq_msb & (A[1] & ~B[1]);
    wire eq_mid = eq_msb & bit_eq[1];

    // LSB comparison (conditional on higher bits equality)
    wire gt_lsb = eq_mid & (A[0] & ~B[0]);

    // Final outputs (area optimized)
    assign A_greater = gt_msb | gt_mid | gt_lsb;
    assign A_equal = eq_mid & bit_eq[0];  // All bits equal
    assign A_less = ~(A_greater | A_equal);  // Derived from others

endmodule