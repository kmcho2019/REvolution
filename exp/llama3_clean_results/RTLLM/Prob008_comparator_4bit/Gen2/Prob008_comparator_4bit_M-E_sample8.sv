module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] borrow;
    assign borrow[0] = ~A[0] & B[0];
    assign borrow[1] = (~A[1] & B[1]) | (borrow[0] & (~A[1] | B[1]));
    assign borrow[2] = (~A[2] & B[2]) | (borrow[1] & (~A[2] | B[2]));
    assign borrow[3] = (~A[3] & B[3]) | (borrow[2] & (~A[3] | B[3]));

    assign A_greater = ~borrow[3] & (A[3] | (A[2] & ~borrow[2]) | (A[1] & ~borrow[1]) | (A[0] & ~borrow[0]));
    assign A_equal   = ~(A > B) & ~(A < B);
    assign A_less    = borrow[3] | (borrow[2] & (~A[2] | B[2])) | (borrow[1] & (~A[1] | B[1])) | (borrow[0] & (~A[0] | B[0]));

endmodule