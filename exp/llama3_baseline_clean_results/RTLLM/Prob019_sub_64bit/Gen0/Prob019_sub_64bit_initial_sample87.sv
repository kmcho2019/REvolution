module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Detect overflow conditions
    assign overflow = (
        // Positive overflow: A is positive, B is negative, and result is negative
        (A[63] == 0 && B[63] == 1 && result[63] == 1) ||
        // Negative overflow: A is negative, B is positive, and result is positive
        (A[63] == 1 && B[63] == 0 && result[63] == 0)
    );

endmodule