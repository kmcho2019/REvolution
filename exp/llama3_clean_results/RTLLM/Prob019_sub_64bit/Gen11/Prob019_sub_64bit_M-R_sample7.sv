module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    assign result = A - B;

    // Calculate the sign bits of A, B, and the result
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];

    // Detect overflow conditions
    assign overflow = (sign_A!= sign_B) && (sign_A!= sign_result);

endmodule