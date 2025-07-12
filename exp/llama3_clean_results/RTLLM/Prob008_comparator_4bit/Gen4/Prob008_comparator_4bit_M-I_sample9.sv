module comparator_4bit(
    input  [3:0] A,
    output       A_greater,
    output       A_equal,
    output       A_less,
    input  [3:0] B
);

    wire [3:0] diff;
    wire borrow;

    assign diff[0] = A[0] - B[0];
    assign borrow = (A[0] < B[0]);
    assign diff[1] = A[1] - B[1] - borrow;
    assign A_less = (A[1] < B[1] &&!borrow) || borrow;
    assign diff[2] = A[2] - B[2] - A_less;
    assign A_greater = (A[2] > B[2] &&!A_less) || (A[1] > B[1] &&!A_less);
    assign diff[3] = A[3] - B[3] - A_greater;
    assign A_equal = (diff[3] == 0 && diff[2] == 0 && diff[1] == 0 && diff[0] == 0);

endmodule