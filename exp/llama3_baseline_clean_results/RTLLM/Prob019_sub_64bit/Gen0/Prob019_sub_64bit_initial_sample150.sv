module sub_64bit(
    input [63:0] A, // First 64-bit input operand
    input [63:0] B, // Second 64-bit input operand
    output [63:0] result, // 64-bit output representing the difference of the two operands (A - B)
    output overflow // 1-bit output indicating whether an overflow occurred during the subtraction operation
);

// Perform binary subtraction
assign result = A - B;

// Determine the sign of A, B, and the result
wire A_sign = A[63]; // MSB of A
wire B_sign = B[63]; // MSB of B
wire result_sign = result[63]; // MSB of the result

// Check for overflow conditions
assign overflow = (A_sign == 0 && B_sign == 1 && result_sign == 1) || // Positive overflow
                  (A_sign == 1 && B_sign == 0 && result_sign == 0); // Negative overflow

endmodule