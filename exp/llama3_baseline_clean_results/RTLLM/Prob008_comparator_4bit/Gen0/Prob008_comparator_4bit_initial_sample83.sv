module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction A - B using full subtractor logic
    wire [3:0] diff;
    wire borrow;

    assign diff[0] = A[0] - B[0];
    assign diff[1] = A[1] - B[1];
    assign diff[2] = A[2] - B[2];
    assign diff[3] = A[3] - B[3];

    assign borrow = (B[0] > A[0]) | ((B[0] == A[0]) & (B[1] > A[1])) | ((B[0] == A[0]) & (B[1] == A[1]) & (B[2] > A[2])) | ((B[0] == A[0]) & (B[1] == A[1]) & (B[2] == A[2]) & (B[3] > A[3]));

    // Determine A_greater
    assign A_greater = ~borrow & (|diff);

    // Determine A_equal
    assign A_equal = ~(A_greater | A_less) & ~borrow;

    // Determine A_less
    assign A_less = borrow;

endmodule