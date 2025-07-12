module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit2_gt = (A[2] & ~B[2]);
    wire bit2_lt = (~A[2] & B[2]);
    wire bit2_eq = ~(bit2_gt | bit2_lt);

    wire bit1_gt = (A[1] & ~B[1]);
    wire bit1_lt = (~A[1] & B[1]);
    wire bit1_eq = ~(bit1_gt | bit1_lt);

    wire bit0_gt = (A[0] & ~B[0]);
    wire bit0_lt = (~A[0] & B[0]);
    wire bit0_eq = ~(bit0_gt | bit0_lt);

    assign A_greater = bit2_gt | (bit2_eq & bit1_gt) | (bit2_eq & bit1_eq & bit0_gt);
    assign A_less    = bit2_lt | (bit2_eq & bit1_lt) | (bit2_eq & bit1_eq & bit0_lt);
    assign A_equal   = bit2_eq & bit1_eq & bit0_eq;

endmodule