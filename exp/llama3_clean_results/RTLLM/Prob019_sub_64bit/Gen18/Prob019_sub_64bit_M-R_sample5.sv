module sub_64bit(
    input  logic [63:0] A,
    input  logic [63:0] B,
    output logic [63:0] result,
    output logic         overflow
);

    // Directly calculate the result of A - B
    assign result = A - B;

    // Check for overflow conditions
    // Positive overflow: A is positive, B is negative, and result is negative
    // Negative overflow: A is negative, B is positive, and result is positive
    assign overflow = (A[63] == 0 && B[63] == 1 && result[63] == 1) || (A[63] == 1 && B[63] == 0 && result[63] == 0);

endmodule