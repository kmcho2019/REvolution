module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits of operands and result
    wire sign_A   = A[63];
    wire sign_B   = B[63];
    wire sign_res = result[63];

    // Overflow detection:
    // Positive overflow: A positive (0) - B negative (1) = result negative (1)
    wire pos_overflow = (~sign_A) & sign_B & sign_res;

    // Negative overflow: A negative (1) - B positive (0) = result positive (0)
    wire neg_overflow = sign_A & (~sign_B) & (~sign_res);

    // Overflow flag set if either positive or negative overflow occurs
    assign overflow = pos_overflow | neg_overflow;

endmodule