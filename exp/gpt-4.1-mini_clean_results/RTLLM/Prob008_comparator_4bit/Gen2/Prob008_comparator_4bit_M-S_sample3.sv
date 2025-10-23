module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare bits from MSB to LSB
    wire bit3_gt = (A[3] & ~B[3]);
    wire bit3_lt = (~A[3] & B[3]);

    wire bit2_gt = (A[2] & ~B[2]) & ~(bit3_gt | bit3_lt);
    wire bit2_lt = (~A[2] & B[2]) & ~(bit3_gt | bit3_lt);

    wire bit1_gt = (A[1] & ~B[1]) & ~(bit3_gt | bit3_lt | bit2_gt | bit2_lt);
    wire bit1_lt = (~A[1] & B[1]) & ~(bit3_gt | bit3_lt | bit2_gt | bit2_lt);

    wire bit0_gt = (A[0] & ~B[0]) & ~(bit3_gt | bit3_lt | bit2_gt | bit2_lt | bit1_gt | bit1_lt);
    wire bit0_lt = (~A[0] & B[0]) & ~(bit3_gt | bit3_lt | bit2_gt | bit2_lt | bit1_gt | bit1_lt);

    assign A_greater = bit3_gt | bit2_gt | bit1_gt | bit0_gt;
    assign A_less    = bit3_lt | bit2_lt | bit1_lt | bit0_lt;
    assign A_equal   = ~(A_greater | A_less);

endmodule