module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire A_sign     = A[63];
    wire B_sign     = B[63];
    wire result_sign= result[63];

    // Overflow conditions
    // Positive overflow: A positive - B negative = result negative
    wire pos_overflow = (~A_sign) & B_sign & result_sign;

    // Negative overflow: A negative - B positive = result positive
    wire neg_overflow = A_sign & (~B_sign) & (~result_sign);

    // Set overflow flag if either overflow occurs
    assign overflow = pos_overflow | neg_overflow;

endmodule