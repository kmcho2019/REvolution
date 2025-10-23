module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform the 64-bit signed subtraction
    assign result = A - B;

    // Optimized overflow detection:
    // Positive overflow: A positive, B negative, result negative
    // Negative overflow: A negative, B positive, result positive
    // Combined using XOR for efficiency: overflow when sign(A) != sign(B) and sign(A) != sign(result)
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule