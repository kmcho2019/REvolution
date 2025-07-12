module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] sum = A + B_comp + 1'b1;

    // Result assignment
    assign result = sum;

    // Overflow occurs when:
    // 1. A positive, B negative, result negative (positive overflow)
    // 2. A negative, B positive, result positive (negative overflow)
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule