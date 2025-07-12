module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise comparison signals for each bit
    wire bit3_gt = (A[3] & ~B[3]);
    wire bit3_lt = (~A[3] & B[3]);
    wire bit3_eq = ~(A[3] ^ B[3]);

    wire bit2_gt = (A[2] & ~B[2]);
    wire bit2_lt = (~A[2] & B[2]);
    wire bit2_eq = ~(A[2] ^ B[2]);

    wire bit1_gt = (A[1] & ~B[1]);
    wire bit1_lt = (~A[1] & B[1]);
    wire bit1_eq = ~(A[1] ^ B[1]);

    wire bit0_gt = (A[0] & ~B[0]);
    wire bit0_lt = (~A[0] & B[0]);
    wire bit0_eq = ~(A[0] ^ B[0]);

    // Priority logic to determine A > B
    assign A_greater = 
        bit3_gt ? 1'b1 :
        (bit3_eq & bit2_gt) ? 1'b1 :
        (bit3_eq & bit2_eq & bit1_gt) ? 1'b1 :
        (bit3_eq & bit2_eq & bit1_eq & bit0_gt) ? 1'b1 : 1'b0;

    // Priority logic to determine A < B
    assign A_less = 
        bit3_lt ? 1'b1 :
        (bit3_eq & bit2_lt) ? 1'b1 :
        (bit3_eq & bit2_eq & bit1_lt) ? 1'b1 :
        (bit3_eq & bit2_eq & bit1_eq & bit0_lt) ? 1'b1 : 1'b0;

    // If none greater nor less, then equal
    assign A_equal = ~(A_greater | A_less);

endmodule