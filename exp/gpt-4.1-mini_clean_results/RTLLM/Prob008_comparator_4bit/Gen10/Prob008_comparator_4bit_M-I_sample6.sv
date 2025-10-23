module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality check: all bits equal
    wire equal_bits = &(~(A ^ B));

    // Comparison from MSB to LSB
    // Determine if A > B or A < B by checking highest differing bit
    wire gt3 = (A[3] & ~B[3]);
    wire lt3 = (~A[3] & B[3]);

    wire gt2 = (A[2] & ~B[2]);
    wire lt2 = (~A[2] & B[2]);

    wire gt1 = (A[1] & ~B[1]);
    wire lt1 = (~A[1] & B[1]);

    wire gt0 = (A[0] & ~B[0]);
    wire lt0 = (~A[0] & B[0]);

    // Priority encoded comparison
    assign A_greater = gt3 ? 1'b1 :
                       ( (A[3] == B[3]) ? (gt2 ? 1'b1 :
                                           ( (A[2] == B[2]) ? (gt1 ? 1'b1 :
                                                               ( (A[1] == B[1]) ? (gt0 ? 1'b1 : 1'b0) : 1'b0)) : 1'b0)) : 1'b0);

    assign A_less    = lt3 ? 1'b1 :
                       ( (A[3] == B[3]) ? (lt2 ? 1'b1 :
                                           ( (A[2] == B[2]) ? (lt1 ? 1'b1 :
                                                               ( (A[1] == B[1]) ? (lt0 ? 1'b1 : 1'b0) : 1'b0)) : 1'b0)) : 1'b0);

    assign A_equal = equal_bits;

endmodule