module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Parallel magnitude comparison (arithmetic-inspired)
    wire [2:0] A_gt_B_bit = A & ~B;
    wire [2:0] A_eq_B_bit = ~(A ^ B);
    wire [2:0] A_lt_B_bit = ~A & B;

    // Hierarchical comparison with early termination
    wire gt_msb = A_gt_B_bit[2];
    wire eq_msb = A_eq_B_bit[2];
    wire lt_msb = A_lt_B_bit[2];

    wire gt_mid = eq_msb & A_gt_B_bit[1];
    wire eq_mid = eq_msb & A_eq_B_bit[1];
    wire lt_mid = eq_msb & A_lt_B_bit[1];

    wire gt_lsb = eq_mid & A_gt_B_bit[0];
    wire eq_lsb = eq_mid & A_eq_B_bit[0];
    wire lt_lsb = eq_mid & A_lt_B_bit[0];

    // Final output assignment
    assign A_greater = gt_msb | gt_mid | gt_lsb;
    assign A_equal = eq_lsb;
    assign A_less = lt_msb | lt_mid | lt_lsb;

endmodule