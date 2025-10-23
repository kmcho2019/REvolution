module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise equality and magnitude comparison
    wire [2:0] bit_eq = ~(A ^ B);
    wire [2:0] bit_gt = A & ~B;

    // Detect first unequal bit from MSB to LSB
    wire msb_neq = ~bit_eq[2];
    wire mid_neq = ~bit_eq[1] & bit_eq[2];
    wire lsb_neq = ~bit_eq[0] & bit_eq[2] & bit_eq[1];

    // Generate comparison results based on first unequal bit
    assign A_greater = (msb_neq & bit_gt[2]) |
                      (mid_neq & bit_gt[1]) |
                      (lsb_neq & bit_gt[0]);

    assign A_equal = &bit_eq;  // All bits equal

    // A_less is mutually exclusive with the other outputs
    assign A_less = ~A_equal & ~A_greater;

endmodule