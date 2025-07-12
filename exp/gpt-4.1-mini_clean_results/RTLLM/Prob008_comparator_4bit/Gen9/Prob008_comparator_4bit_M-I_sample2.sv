module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Check bit differences starting from MSB to LSB
    wire bit3_gt = A[3] & ~B[3];
    wire bit3_lt = ~A[3] & B[3];

    wire bit2_gt = A[2] & ~B[2];
    wire bit2_lt = ~A[2] & B[2];

    wire bit1_gt = A[1] & ~B[1];
    wire bit1_lt = ~A[1] & B[1];

    wire bit0_gt = A[0] & ~B[0];
    wire bit0_lt = ~A[0] & B[0];

    // Determine A_greater: first higher bit where A > B
    assign A_greater = bit3_gt
                    | (~(bit3_gt | bit3_lt) & bit2_gt)
                    | (~(bit3_gt | bit3_lt | bit2_gt | bit2_lt) & bit1_gt)
                    | (~(bit3_gt | bit3_lt | bit2_gt | bit2_lt | bit1_gt | bit1_lt) & bit0_gt);

    // Determine A_less: first higher bit where A < B
    assign A_less = bit3_lt
                 | (~(bit3_gt | bit3_lt) & bit2_lt)
                 | (~(bit3_gt | bit3_lt | bit2_gt | bit2_lt) & bit1_lt)
                 | (~(bit3_gt | bit3_lt | bit2_gt | bit2_lt | bit1_gt | bit1_lt) & bit0_lt);

    // Determine equality: no differing bits
    assign A_equal = ~(A_greater | A_less);

endmodule