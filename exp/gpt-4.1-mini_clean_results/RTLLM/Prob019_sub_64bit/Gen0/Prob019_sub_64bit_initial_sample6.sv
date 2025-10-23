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

    // Overflow detection for subtraction:
    // Overflow if:
    // - A is positive (0), B is negative (1), and result is negative (1)
    // - A is negative (1), B is positive (0), and result is positive (0)
    assign overflow = (~A_sign & B_sign & R_sign) | (A_sign & ~B_sign & ~R_sign);

endmodule