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

    // Overflow detection
    // Overflow if A positive & B negative & result negative (positive overflow)
    // or A negative & B positive & result positive (negative overflow)
    assign overflow = (A_sign == 1'b0 && B_sign == 1'b1 && result_sign == 1'b1) ||
                      (A_sign == 1'b1 && B_sign == 1'b0 && result_sign == 1'b0);

endmodule