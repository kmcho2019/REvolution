module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] result;
    wire borrow;

    assign result = A - B;
    assign borrow = (B[0] > A[0]) | ((B[0] == A[0]) & (B[1] > A[1])) | ((B[0:1] == A[0:1]) & (B[2] > A[2])) | ((B[0:2] == A[0:2]) & (B[3] > A[3]));

    assign A_greater = ~borrow & (|result);
    assign A_equal = ~borrow & ~(|result);
    assign A_less = borrow;

endmodule