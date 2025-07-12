module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction using built-in operator
    assign result = A - B;

    // Extract sign bits
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    // Overflow detection:
    // Positive overflow: A positive, B negative, result negative
    // Negative overflow: A negative, B positive, result positive
    assign overflow = ((~A_sign & B_sign & result_sign) | (A_sign & ~B_sign & ~result_sign));

endmodule