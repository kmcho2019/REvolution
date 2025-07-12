module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate borrow signals
    wire borrow1, borrow2, borrow3;

    // Subtract bit 0: borrow1 = (~A[0] & B[0])
    assign borrow1 = (~A[0] & B[0]);

    // Subtract bit 1: borrow2 = ((~A[1] & B[1]) | ((~A[1] | B[1]) & borrow1))
    assign borrow2 = ((~A[1] & B[1]) | (((~A[1]) | B[1]) & borrow1));

    // Subtract bit 2: borrow3 = ((~A[2] & B[2]) | ((~A[2] | B[2]) & borrow2))
    assign borrow3 = ((~A[2] & B[2]) | (((~A[2]) | B[2]) & borrow2));

    // If borrow3=1, then A < B
    assign A_less = borrow3;

    // Check equality: A == B
    assign A_equal = (A == B);

    // A_greater is true when not equal and not less
    assign A_greater = (~A_less) & (~A_equal);

endmodule