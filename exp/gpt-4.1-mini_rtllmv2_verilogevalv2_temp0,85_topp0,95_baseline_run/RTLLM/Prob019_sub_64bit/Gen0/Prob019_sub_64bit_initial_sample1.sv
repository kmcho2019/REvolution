module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    // Overflow detection:
    // Positive overflow: A >= 0, B < 0, result < 0
    // Negative overflow: A < 0, B >= 0, result >= 0
    assign overflow = (~A_sign & B_sign & result_sign) | (A_sign & ~B_sign & ~result_sign);

endmodule