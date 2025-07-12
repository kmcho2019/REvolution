module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit3_gt =  A[3] & ~B[3];
    wire bit3_lt = ~A[3] &  B[3];
    wire bit3_eq = ~(bit3_gt | bit3_lt);

    wire bit2_gt =  A[2] & ~B[2];
    wire bit2_lt = ~A[2] &  B[2];
    wire bit2_eq = ~(bit2_gt | bit2_lt);

    wire bit1_gt =  A[1] & ~B[1];
    wire bit1_lt = ~A[1] &  B[1];
    wire bit1_eq = ~(bit1_gt | bit1_lt);

    wire bit0_gt =  A[0] & ~B[0];
    wire bit0_lt = ~A[0] &  B[0];
    wire bit0_eq = ~(bit0_gt | bit0_lt);

    // Priority encoding starting from MSB down to LSB
    assign A_greater = bit3_gt ? 1'b1 :
                       (bit3_eq & bit2_gt) ? 1'b1 :
                       (bit3_eq & bit2_eq & bit1_gt) ? 1'b1 :
                       (bit3_eq & bit2_eq & bit1_eq & bit0_gt) ? 1'b1 : 1'b0;

    assign A_less = bit3_lt ? 1'b1 :
                    (bit3_eq & bit2_lt) ? 1'b1 :
                    (bit3_eq & bit2_eq & bit1_lt) ? 1'b1 :
                    (bit3_eq & bit2_eq & bit1_eq & bit0_lt) ? 1'b1 : 1'b0;

    assign A_equal = bit3_eq & bit2_eq & bit1_eq & bit0_eq;

endmodule