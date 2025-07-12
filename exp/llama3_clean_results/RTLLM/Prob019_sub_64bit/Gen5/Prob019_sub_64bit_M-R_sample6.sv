module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output logic overflow
);

    // Calculate the result of the subtraction
    assign result = A - B;

    // Check for overflow conditions based on the signs of A, B, and the result
    assign overflow = ((A[63] == 0 && B[63] == 1 && result[63] == 1) || (A[63] == 1 && B[63] == 0 && result[63] == 0));

endmodule