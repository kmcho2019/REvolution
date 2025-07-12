module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Direct subtraction using Verilog's built-in operator
    assign result = A - B;

    // Overflow detection
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule