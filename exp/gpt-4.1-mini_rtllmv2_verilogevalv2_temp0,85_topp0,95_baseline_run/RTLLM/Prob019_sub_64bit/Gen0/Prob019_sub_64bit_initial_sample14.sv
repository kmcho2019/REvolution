module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow detection:
    // Positive overflow: A positive, B negative, result negative
    wire pos_overflow = (~sign_A) & sign_B & sign_result;
    // Negative overflow: A negative, B positive, result positive
    wire neg_overflow = sign_A & (~sign_B) & (~sign_result);

    assign overflow = pos_overflow | neg_overflow;

endmodule