module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform subtraction operation
    assign result = A - B;

    // Check for overflow conditions
    assign overflow = (A[63] == 0 && B[63] == 1 && result[63] == 1) ||  // Positive overflow
                     (A[63] == 1 && B[63] == 0 && result[63] == 0);  // Negative overflow

endmodule