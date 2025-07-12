module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire borrow0, borrow1, borrow2, borrow3;

    // Borrow chain for subtraction A - B
    assign borrow0 = (~A[0] & B[0]);
    assign borrow1 = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & borrow0);
    assign borrow2 = (~A[2] & B[2]) | ((~(A[2] ^ B[2])) & borrow1);
    assign borrow3 = (~A[3] & B[3]) | ((~(A[3] ^ B[3])) & borrow2);

    // Equality check
    wire eq = (A == B);

    // Outputs mutually exclusive
    assign A_less    = borrow3;
    assign A_equal   = (~borrow3) & eq;
    assign A_greater = (~borrow3) & (~eq);

endmodule