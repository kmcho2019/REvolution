module sub_64bit(
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output          overflow
);

    // Perform binary subtraction of A and B to obtain the result
    assign result = A - B;

    // Determine the sign of A, B, and the result
    wire signed_A = $signed(A[63]);
    wire signed_B = $signed(B[63]);
    wire signed_result = $signed(result[63]);

    // Check for overflow conditions
    // Positive overflow: A is positive, B is negative, and the result is negative
    // Negative overflow: A is negative, B is positive, and the result is positive
    assign overflow = (~signed_A & signed_B & signed_result) | (signed_A & ~signed_B & ~signed_result);

endmodule