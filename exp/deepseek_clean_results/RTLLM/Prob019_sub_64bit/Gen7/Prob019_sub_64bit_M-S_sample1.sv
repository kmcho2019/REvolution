module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Main subtraction operation
    assign result = A - B;

    // Optimized overflow detection:
    // Overflow occurs when the sign of the result differs from what we'd expect
    // based on the signs of the inputs (A and -B)
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule