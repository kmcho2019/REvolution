module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire bit2_greater, bit2_less, bit2_equal;
    wire bit1_greater, bit1_less, bit1_equal;
    wire bit0_greater, bit0_less, bit0_equal;

    // Compare bit 2 (MSB)
    assign bit2_greater = A[2] & ~B[2];
    assign bit2_less    = ~A[2] & B[2];
    assign bit2_equal   = ~(bit2_greater | bit2_less);

    // Compare bit 1
    assign bit1_greater = A[1] & ~B[1];
    assign bit1_less    = ~A[1] & B[1];
    assign bit1_equal   = ~(bit1_greater | bit1_less);

    // Compare bit 0 (LSB)
    assign bit0_greater = A[0] & ~B[0];
    assign bit0_less    = ~A[0] & B[0];
    assign bit0_equal   = ~(bit0_greater | bit0_less);

    // Hierarchical comparison from MSB to LSB
    assign A_greater = bit2_greater | (bit2_equal & bit1_greater) | (bit2_equal & bit1_equal & bit0_greater);
    assign A_less    = bit2_less    | (bit2_equal & bit1_less)    | (bit2_equal & bit1_equal & bit0_less);
    assign A_equal   = bit2_equal   & bit1_equal                  & bit0_equal;

endmodule