module sub_64bit(
    input [63:0] A,  // First 64-bit input operand
    input [63:0] B,  // Second 64-bit input operand
    output [63:0] result,  // 64-bit output representing the difference of the two operands (A - B)
    output overflow  // 1-bit output indicating whether an overflow occurred during the subtraction operation
);

// Perform binary subtraction of A and B to obtain the result
assign result = A - B;

// Determine the sign bits of A, B, and the result
wire sign_A = A[63];  // Sign bit of A (0 for positive, 1 for negative)
wire sign_B = B[63];  // Sign bit of B (0 for positive, 1 for negative)
wire sign_result = result[63];  // Sign bit of the result (0 for positive, 1 for negative)

// Check for overflow conditions based on the sign bits
// Positive overflow occurs when a positive number (A) is subtracted by a negative number (B) and the result is negative
// Negative overflow occurs when a negative number (A) is subtracted by a positive number (B) and the result is positive
assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_result == 1'b1) || 
                  (sign_A == 1'b1 && sign_B == 1'b0 && sign_result == 1'b0);

endmodule