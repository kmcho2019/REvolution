module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit2_gt, bit2_eq, bit2_lt;
    wire bit1_gt, bit1_eq, bit1_lt;
    wire bit0_gt, bit0_eq, bit0_lt;

    // Compare bit 2 (MSB)
    assign bit2_gt = (A[2] & ~B[2]);
    assign bit2_lt = (~A[2] & B[2]);
    assign bit2_eq = ~(bit2_gt | bit2_lt);

    // Compare bit 1
    assign bit1_gt = (A[1] & ~B[1]);
    assign bit1_lt = (~A[1] & B[1]);
    assign bit1_eq = ~(bit1_gt | bit1_lt);

    // Compare bit 0 (LSB)
    assign bit0_gt = (A[0] & ~B[0]);
    assign bit0_lt = (~A[0] & B[0]);
    assign bit0_eq = ~(bit0_gt | bit0_lt);

    // Determine overall comparison by cascading from MSB to LSB
    assign A_greater = bit2_gt ? 1'b1 :
                       (bit2_eq & bit1_gt) ? 1'b1 :
                       (bit2_eq & bit1_eq & bit0_gt) ? 1'b1 : 1'b0;

    assign A_less =    bit2_lt ? 1'b1 :
                       (bit2_eq & bit1_lt) ? 1'b1 :
                       (bit2_eq & bit1_eq & bit0_lt) ? 1'b1 : 1'b0;

    assign A_equal = ~(A_greater | A_less);

endmodule