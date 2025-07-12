module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction and generate borrow flag
    wire [3:0] diff;
    wire borrow;

    assign diff[0] = A[0] - B[0];
    assign borrow = (A[0] < B[0]);
    assign diff[1] = A[1] - B[1] - borrow;
    assign borrow = (A[1] < B[1]) | (borrow & (A[1] == B[1]));
    assign diff[2] = A[2] - B[2] - borrow;
    assign borrow = (A[2] < B[2]) | (borrow & (A[2] == B[2]));
    assign diff[3] = A[3] - B[3] - borrow;

    // Determine the outputs based on the result of subtraction and borrow
    assign A_greater = (~borrow) & (|diff); // diff is non-zero and no borrow
    assign A_equal = ~(|diff) & ~borrow;    // diff is zero and no borrow
    assign A_less = borrow;                  // borrow occurred

endmodule