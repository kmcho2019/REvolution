module sub_64bit (
    input   [63:0] A,  // First 64-bit input operand
    input   [63:0] B,  // Second 64-bit input operand
    output  [63:0] result,  // 64-bit output representing the difference of the two operands (A - B)
    output         overflow  // 1-bit output indicating whether an overflow occurred during the subtraction operation
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Define the sign bits of A, B, and the result for clarity
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];

    // Check for overflow conditions
    // Positive overflow: A is positive, B is negative, and the result is negative
    // Negative overflow: A is negative, B is positive, and the result is positive
    assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_result == 1'b1) ||  // Positive overflow
                     (sign_A == 1'b1 && sign_B == 1'b0 && sign_result == 1'b0);  // Negative overflow

    // Consider applying synthesis tool directives for further optimization
    // For example, using attributes to guide area or power optimization
    // However, the exact directives will depend on the target technology and synthesis tool

endmodule