module sub_64bit(
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    wire    [63:0] diff;
    wire             sign_A, sign_B, sign_result;

    // Calculate the difference between A and B
    assign diff = A - B;

    // Extract the sign bits of A, B, and the result
    assign sign_A = A[63];
    assign sign_B = B[63];
    assign sign_result = diff[63];

    // Check for overflow conditions
    assign overflow = (sign_A != sign_B) && (sign_A != sign_result);

    // Assign the result
    assign result = diff;

endmodule