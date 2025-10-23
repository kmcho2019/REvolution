module sub_64bit(
    input [63:0] A,  // First 64-bit input operand
    input [63:0] B,  // Second 64-bit input operand
    output [63:0] result,  // 64-bit output representing the difference of the two operands
    output overflow  // 1-bit output indicating whether an overflow occurred
);

    // Perform binary subtraction
    assign result = A - B;

    // Determine the sign of A, B, and the result
    wire sign_A = A[63];  // Sign bit of A (1 for negative, 0 for positive)
    wire sign_B = B[63];  // Sign bit of B (1 for negative, 0 for positive)
    wire sign_result = result[63];  // Sign bit of the result (1 for negative, 0 for positive)

    // Detect overflow conditions
    wire positive_overflow = (~sign_A) & sign_B & sign_result;  // Positive overflow
    wire negative_overflow = sign_A & (~sign_B) & (~sign_result);  // Negative overflow

    // Set the overflow flag
    assign overflow = positive_overflow | negative_overflow;

endmodule