module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction A - B
    wire [3:0] diff;
    wire borrow;

    assign diff[0] = A[0] - B[0];
    assign borrow = (B[0] > A[0]) ? 1'b1 : 1'b0;

    assign diff[1] = A[1] - B[1] - borrow;
    assign borrow = (B[1] + borrow > A[1]) ? 1'b1 : 1'b0;

    assign diff[2] = A[2] - B[2] - borrow;
    assign borrow = (B[2] + borrow > A[2]) ? 1'b1 : 1'b0;

    assign diff[3] = A[3] - B[3] - borrow;

    // Determine the relationship between A and B based on the result of subtraction
    assign A_greater = (~borrow) && (diff != 4'b0000);
    assign A_equal = (diff == 4'b0000) && ~borrow;
    assign A_less = borrow;

endmodule