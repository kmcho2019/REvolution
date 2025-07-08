module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire R_sign = result[63];

    // Overflow detection
    // Positive overflow: A is positive, B is negative, result is negative
    wire pos_overflow = (~A_sign) & B_sign & R_sign;

    // Negative overflow: A is negative, B is positive, result is positive
    wire neg_overflow = A_sign & (~B_sign) & (~R_sign);

    assign overflow = pos_overflow | neg_overflow;

endmodule