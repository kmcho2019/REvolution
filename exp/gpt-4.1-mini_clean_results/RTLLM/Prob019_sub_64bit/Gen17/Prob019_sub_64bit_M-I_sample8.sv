module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Use built-in subtraction operator for optimized implementation
    assign result = A - B;

    // Overflow detection for signed 64-bit subtraction
    // Positive overflow: A positive, B negative, result negative
    // Negative overflow: A negative, B positive, result positive
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule