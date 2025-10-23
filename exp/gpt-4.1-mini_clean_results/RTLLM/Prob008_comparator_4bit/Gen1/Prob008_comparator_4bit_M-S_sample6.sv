module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bit3_gt = (A[3] & ~B[3]);
    wire bit3_lt = (~A[3] & B[3]);
    wire bit2_gt = (A[2] & ~B[2]);
    wire bit2_lt = (~A[2] & B[2]);
    wire bit1_gt = (A[1] & ~B[1]);
    wire bit1_lt = (~A[1] & B[1]);
    wire bit0_gt = (A[0] & ~B[0]);
    wire bit0_lt = (~A[0] & B[0]);

    assign A_greater = bit3_gt ? 1'b1 :
                       ( (A[3] == B[3]) && bit2_gt ) ? 1'b1 :
                       ( (A[3] == B[3]) && (A[2] == B[2]) && bit1_gt ) ? 1'b1 :
                       ( (A[3] == B[3]) && (A[2] == B[2]) && (A[1] == B[1]) && bit0_gt ) ? 1'b1 : 1'b0;

    assign A_less = bit3_lt ? 1'b1 :
                    ( (A[3] == B[3]) && bit2_lt ) ? 1'b1 :
                    ( (A[3] == B[3]) && (A[2] == B[2]) && bit1_lt ) ? 1'b1 :
                    ( (A[3] == B[3]) && (A[2] == B[2]) && (A[1] == B[1]) && bit0_lt ) ? 1'b1 : 1'b0;

    assign A_equal = ~(A_greater | A_less);

endmodule