module sub_64bit(
    input   [63:0] A,  // First 64-bit input operand
    input   [63:0] B,  // Second 64-bit input operand
    output  [63:0] result,  // 64-bit output representing the difference of A and B
    output          overflow  // 1-bit output indicating whether an overflow occurred
);

    // Perform binary subtraction of A and B
    wire [63:0] temp_result = A - B;

    // Assign the result
    assign result = temp_result;

    // Check for overflow conditions
    assign overflow = (
        // Positive overflow: A is positive, B is negative, and the result is negative
        (~A[63] && B[63] && temp_result[63]) ||
        // Negative overflow: A is negative, B is positive, and the result is positive
        (A[63] && ~B[63] && ~temp_result[63])
    );

endmodule