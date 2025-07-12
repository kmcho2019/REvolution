module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction: A - B
    wire [3:0] diff;
    wire borrow;

    // Calculate the difference and borrow
    assign diff[0] = A[0] - B[0];
    assign borrow = (A[0] < B[0]) ? 1 : 0;
    assign diff[1] = A[1] - B[1] - borrow;
    assign borrow = (A[1] - B[1] < 0) ? 1 : ((A[0] < B[0]) ? 1 : 0);
    assign diff[2] = A[2] - B[2] - borrow;
    assign borrow = (A[2] - B[2] < 0) ? 1 : ((A[1] - B[1] < 0) ? 1 : ((A[0] < B[0]) ? 1 : 0));
    assign diff[3] = A[3] - B[3] - borrow;
    assign borrow = (A[3] - B[3] < 0) ? 1 : ((A[2] - B[2] < 0) ? 1 : ((A[1] - B[1] < 0) ? 1 : ((A[0] < B[0]) ? 1 : 0)));

    // Determine the comparison result based on the difference and borrow
    assign A_less = borrow;
    assign A_equal = (~borrow) & (~|diff);  // |diff is the OR reduction of the diff vector
    assign A_greater = (~borrow) & (|diff);

endmodule