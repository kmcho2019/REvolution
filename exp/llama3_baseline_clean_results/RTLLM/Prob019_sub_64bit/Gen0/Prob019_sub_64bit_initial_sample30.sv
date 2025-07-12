module sub_64bit(
    input   wire    [63:0] A,
    input   wire    [63:0] B,
    output  wire    [63:0] result,
    output  wire             overflow
);

    // Perform the subtraction
    assign result = A - B;

    // Determine the sign of A, B, and the result
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = result[63];

    // Check for positive overflow: A is positive, B is negative, and the result is negative
    wire pos_overflow = ~A_sign & B_sign & result_sign;

    // Check for negative overflow: A is negative, B is positive, and the result is positive
    wire neg_overflow = A_sign & ~B_sign & ~result_sign;

    // Set the overflow flag if either positive or negative overflow is detected
    assign overflow = pos_overflow | neg_overflow;

endmodule