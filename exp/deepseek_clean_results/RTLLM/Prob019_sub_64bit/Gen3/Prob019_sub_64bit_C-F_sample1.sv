module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform the subtraction
    assign result = A - B;

    // Overflow occurs when:
    // 1. Positive overflow: A positive, B negative, result negative
    // 2. Negative overflow: A negative, B positive, result positive
    wire positive_overflow = ~A[63] & B[63] & result[63];
    wire negative_overflow = A[63] & ~B[63] & ~result[63];
    
    assign overflow = positive_overflow | negative_overflow;

endmodule