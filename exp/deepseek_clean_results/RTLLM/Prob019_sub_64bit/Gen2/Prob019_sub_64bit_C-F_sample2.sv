module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform the subtraction
    assign result = A - B;

    // Optimized overflow detection:
    // Overflow occurs when signs of A and B differ and result sign differs from A's sign
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule