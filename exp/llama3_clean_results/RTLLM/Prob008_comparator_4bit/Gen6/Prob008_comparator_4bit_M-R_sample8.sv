module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow;

    // Perform subtraction: A - B
    assign diff[0] = A[0] - B[0];
    assign diff[1] = A[1] - B[1] - borrow;
    assign diff[2] = A[2] - B[2] - borrow;
    assign diff[3] = A[3] - B[3] - borrow;

    // Generate borrow signal
    assign borrow = (A[0] < B[0]) | ((A[0] == B[0]) & (A[1] < B[1])) | ((A[0:1] == B[0:1]) & (A[2] < B[2])) | ((A[0:2] == B[0:2]) & (A[3] < B[3]));

    // Determine relationship based on result and borrow
    assign A_greater = ~borrow & ~(diff == 4'b0);
    assign A_equal   = ~borrow & (diff == 4'b0);
    assign A_less    = borrow;

endmodule