module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Temporary variables for better readability of overflow conditions
    wire a_is_positive = ~A[63];
    wire b_is_positive = ~B[63];
    wire result_is_positive = ~result[63];

    // Check for overflow conditions
    // Positive overflow: A is positive, B is negative, and result is negative
    // Negative overflow: A is negative, B is positive, and result is positive
    assign overflow = (a_is_positive && ~b_is_positive && ~result_is_positive) ||
                      (~a_is_positive && b_is_positive && result_is_positive);

endmodule