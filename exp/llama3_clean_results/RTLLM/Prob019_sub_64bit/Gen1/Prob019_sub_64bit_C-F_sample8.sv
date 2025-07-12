module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Determine the sign of A, B, and the result
    wire A_sign = A[63];  // 1 if A is negative, 0 if A is positive
    wire B_sign = B[63];  // 1 if B is negative, 0 if B is positive
    wire result_sign = result[63];  // 1 if result is negative, 0 if result is positive

    // Detect overflow conditions
    assign overflow = (A_sign == 1'b0 && B_sign == 1'b1 && result_sign == 1'b1) || 
                      (A_sign == 1'b1 && B_sign == 1'b0 && result_sign == 1'b0);

endmodule