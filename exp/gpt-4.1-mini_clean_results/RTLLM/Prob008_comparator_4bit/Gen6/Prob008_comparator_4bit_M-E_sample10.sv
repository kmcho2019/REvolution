module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit3_greater = (A[3] & ~B[3]);
    wire bit3_less    = (~A[3] & B[3]);

    wire bit2_greater = (A[2] & ~B[2]);
    wire bit2_less    = (~A[2] & B[2]);

    wire bit1_greater = (A[1] & ~B[1]);
    wire bit1_less    = (~A[1] & B[1]);

    wire bit0_greater = (A[0] & ~B[0]);
    wire bit0_less    = (~A[0] & B[0]);

    // Determine greater condition by priority from MSB to LSB
    assign A_greater = bit3_greater 
                     | (~(bit3_greater | bit3_less) & bit2_greater)
                     | (~(bit3_greater | bit3_less | bit2_greater | bit2_less) & bit1_greater)
                     | (~(bit3_greater | bit3_less | bit2_greater | bit2_less | bit1_greater | bit1_less) & bit0_greater);

    // Determine less condition similarly
    assign A_less = bit3_less 
                  | (~(bit3_greater | bit3_less) & bit2_less)
                  | (~(bit3_greater | bit3_less | bit2_greater | bit2_less) & bit1_less)
                  | (~(bit3_greater | bit3_less | bit2_greater | bit2_less | bit1_greater | bit1_less) & bit0_less);

    // Equality if all bits are equal (XNOR all bits and reduce AND)
    assign A_equal = &(~(A ^ B));

endmodule