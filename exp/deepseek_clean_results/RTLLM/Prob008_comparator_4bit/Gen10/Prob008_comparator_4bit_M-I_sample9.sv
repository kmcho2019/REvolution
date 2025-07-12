module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise comparison signals (XNOR for lower power)
    wire [3:0] bit_eq = A ~^ B;  // XNOR for equality
    wire [3:0] bit_gt = A & ~B;  // Generate greater signals

    // Carry-lookahead style comparison
    wire cmp = bit_gt[3] |
              (bit_eq[3] & bit_gt[2]) |
              (bit_eq[3] & bit_eq[2] & bit_gt[1]) |
              (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);

    // Final outputs
    assign A_equal = &bit_eq;
    assign A_greater = cmp & ~A_equal;
    assign A_less = ~A_equal & ~cmp;  // Derived from other two outputs

endmodule