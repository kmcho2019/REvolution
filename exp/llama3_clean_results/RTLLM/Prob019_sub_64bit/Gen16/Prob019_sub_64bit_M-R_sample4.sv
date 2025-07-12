module sub_64bit(
    input  wire [63:0] A,  // First 64-bit input operand
    input  wire [63:0] B,  // Second 64-bit input operand
    output wire [63:0] result,  // 64-bit output representing the difference of A and B
    output wire        overflow  // 1-bit output indicating whether an overflow occurred
);

    // Internal signal to store the subtraction result
    wire [63:0] subtract_result;

    // Perform binary subtraction of A and B
    assign subtract_result = A - B;

    // Assign the result
    assign result = subtract_result;

    // Determine the overflow condition
    // An overflow occurs when A and B have the same sign but the result has a different sign
    wire A_is_negative = A[63];  // A is negative if its most significant bit (MSB) is 1
    wire B_is_negative = B[63];  // B is negative if its MSB is 1
    wire result_is_negative = subtract_result[63];  // Result is negative if its MSB is 1

    // Overflow condition: A and B have the same sign, but the result has a different sign
    assign overflow = (A_is_negative == B_is_negative) && (A_is_negative != result_is_negative);

endmodule