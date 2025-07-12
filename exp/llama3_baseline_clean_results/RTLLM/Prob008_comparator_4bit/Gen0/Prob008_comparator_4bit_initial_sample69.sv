module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction: A - B
    wire [3:0] diff;
    assign diff = A - B;

    // Generate borrow signal (A less than B)
    wire borrow;
    assign borrow = (A[3] == 0 && B[3] == 1) || 
                    (A[3] == 0 && B[3] == 0 && A[2] == 0 && B[2] == 1) || 
                    (A[3] == 0 && B[3] == 0 && A[2] == 0 && B[2] == 0 && A[1] == 0 && B[1] == 1) || 
                    (A[3] == 0 && B[3] == 0 && A[2] == 0 && B[2] == 0 && A[1] == 0 && B[1] == 0 && A[0] == 0 && B[0] == 1);

    // A is greater than B if no borrow and difference is non-zero
    assign A_greater = (~borrow) && (diff != 0);

    // A is equal to B if difference is zero and no borrow
    assign A_equal = (~borrow) && (diff == 0);

    // A is less than B if borrow occurs
    assign A_less = borrow;

endmodule