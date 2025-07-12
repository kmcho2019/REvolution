module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform subtraction and overflow detection in parallel
    assign result = A - B;
    
    // Combined overflow detection expression
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule