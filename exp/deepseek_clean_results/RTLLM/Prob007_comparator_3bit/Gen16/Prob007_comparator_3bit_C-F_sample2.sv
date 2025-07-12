module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals (optimized)
    wire [2:0] bit_eq = ~(A ^ B);
    wire [2:0] bit_gt = A & ~B;

    // Priority comparison from MSB to LSB
    wire gt_msb = bit_gt[2];
    wire eq_msb = bit_eq[2];
    
    wire gt_mid = eq_msb & bit_gt[1];
    wire eq_mid = eq_msb & bit_eq[1];
    
    wire gt_lsb = eq_mid & bit_gt[0];
    
    // Final outputs (mutually exclusive)
    assign A_greater = gt_msb | gt_mid | gt_lsb;
    assign A_equal   = eq_mid & bit_eq[0];  // All bits equal
    assign A_less    = ~A_greater & ~A_equal;

endmodule