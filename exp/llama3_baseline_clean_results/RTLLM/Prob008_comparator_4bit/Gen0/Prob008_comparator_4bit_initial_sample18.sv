module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] diff;
    wire borrow;

    // Perform subtraction A - B
    assign diff[0] = A[0] ^ B[0] ^ borrow;
    assign diff[1] = A[1] ^ B[1] ^ borrow;
    assign diff[2] = A[2] ^ B[2] ^ borrow;
    assign diff[3] = A[3] ^ B[3] ^ borrow;

    // Generate borrow signal
    assign borrow = (A[0] == 0 && B[0] == 1) ||
                    (A[1] == 0 && B[1] == 1 && A[0] == 1 && B[0] == 1) ||
                    (A[2] == 0 && B[2] == 1 && A[1] == 1 && B[1] == 1 && A[0] == 1 && B[0] == 1) ||
                    (A[3] == 0 && B[3] == 1 && A[2] == 1 && B[2] == 1 && A[1] == 1 && B[1] == 1 && A[0] == 1 && B[0] == 1);

    // Determine A_greater, A_equal, A_less based on result of subtraction
    assign A_greater = ~(borrow) && (|diff);
    assign A_equal = ~(borrow) && ~(|diff);
    assign A_less = borrow;

endmodule