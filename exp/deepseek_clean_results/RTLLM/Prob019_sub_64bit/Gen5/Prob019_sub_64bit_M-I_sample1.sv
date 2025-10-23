module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Direct subtraction and sign extraction
    assign result = A - B;
    wire result_sign = result[63];
    
    // Optimized XOR-based overflow detection
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result_sign);

endmodule