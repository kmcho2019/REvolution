module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit2_greater = A[2] & ~B[2];
    wire bit2_less    = ~A[2] & B[2];

    wire bit1_greater = A[1] & ~B[1];
    wire bit1_less    = ~A[1] & B[1];

    wire bit0_greater = A[0] & ~B[0];
    wire bit0_less    = ~A[0] & B[0];

    assign A_greater = bit2_greater
                     | (~(bit2_greater | bit2_less) & bit1_greater)
                     | (~(bit2_greater | bit2_less) & ~(bit1_greater | bit1_less) & bit0_greater);

    assign A_less    = bit2_less
                     | (~(bit2_greater | bit2_less) & bit1_less)
                     | (~(bit2_greater | bit2_less) & ~(bit1_greater | bit1_less) & bit0_less);

    assign A_equal   = ~(A_greater | A_less);

endmodule