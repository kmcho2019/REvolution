module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare bit 3 (MSB)
    wire bit3_gt = (A[3] & ~B[3]);
    wire bit3_lt = (~A[3] & B[3]);

    // Compare bit 2
    wire bit2_gt = (A[2] & ~B[2]);
    wire bit2_lt = (~A[2] & B[2]);

    // Compare bit 1
    wire bit1_gt = (A[1] & ~B[1]);
    wire bit1_lt = (~A[1] & B[1]);

    // Compare bit 0 (LSB)
    wire bit0_gt = (A[0] & ~B[0]);
    wire bit0_lt = (~A[0] & B[0]);

    // Determine greater and less signals with priority from MSB to LSB
    assign A_greater =   bit3_gt
                      | (~bit3_gt & ~bit3_lt & bit2_gt)
                      | (~bit3_gt & ~bit3_lt & ~bit2_gt & ~bit2_lt & bit1_gt)
                      | (~bit3_gt & ~bit3_lt & ~bit2_gt & ~bit2_lt & ~bit1_gt & ~bit1_lt & bit0_gt);

    assign A_less    =   bit3_lt
                      | (~bit3_gt & ~bit3_lt & bit2_lt)
                      | (~bit3_gt & ~bit3_lt & ~bit2_gt & ~bit2_lt & bit1_lt)
                      | (~bit3_gt & ~bit3_lt & ~bit2_gt & ~bit2_lt & ~bit1_gt & ~bit1_lt & bit0_lt);

    // Equality if all bits equal
    wire eq3 = ~(A[3] ^ B[3]);
    wire eq2 = ~(A[2] ^ B[2]);
    wire eq1 = ~(A[1] ^ B[1]);
    wire eq0 = ~(A[0] ^ B[0]);

    assign A_equal = eq3 & eq2 & eq1 & eq0;

endmodule