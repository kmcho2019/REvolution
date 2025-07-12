module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Direct subtraction using Verilog arithmetic
    assign result = A - B;

    // Overflow occurs when:
    // 1. Subtracting negative from positive gives negative result, or
    // 2. Subtracting positive from negative gives positive result
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule