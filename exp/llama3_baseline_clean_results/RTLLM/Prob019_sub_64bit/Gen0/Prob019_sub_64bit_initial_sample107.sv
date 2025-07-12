module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform the subtraction
    assign result = A - B;

    // Check for overflow
    // Positive overflow occurs when A is positive, B is negative, and the result is negative
    // Negative overflow occurs when A is negative, B is positive, and the result is positive
    assign overflow = ((A[63] == 0 && B[63] == 1 && result[63] == 1) || 
                      (A[63] == 1 && B[63] == 0 && result[63] == 0));

endmodule