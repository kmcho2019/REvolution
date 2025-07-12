module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform subtraction
    assign result = A - B;

    // Determine the signs of A, B, and the result
    wire sign_A = A[63]; // MSB of A
    wire sign_B = B[63]; // MSB of B
    wire sign_result = result[63]; // MSB of result

    // Overflow condition checks
    // Positive overflow: A is positive, B is negative, result is negative
    // Negative overflow: A is negative, B is positive, result is positive
    assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_result == 1'b1) || 
                     (sign_A == 1'b1 && sign_B == 1'b0 && sign_result == 1'b0);

endmodule