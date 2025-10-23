module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire diff_bits;
    wire AgtB_2, AgtB_1, AgtB_0;

    // Equality: if none of the bits differ, then equal
    assign diff_bits = |(A ^ B);
    assign A_equal = ~diff_bits;

    // Greater comparison by bit significance
    assign AgtB_2 = A[2] & ~B[2];
    assign AgtB_1 = (~A[2] & ~B[2]) & (A[1] & ~B[1]);
    assign AgtB_0 = (~A[2] & ~B[2]) & (~A[1] & ~B[1]) & (A[0] & ~B[0]);

    assign A_greater = AgtB_2 | AgtB_1 | AgtB_0;
    assign A_less = ~A_equal & ~A_greater;

endmodule