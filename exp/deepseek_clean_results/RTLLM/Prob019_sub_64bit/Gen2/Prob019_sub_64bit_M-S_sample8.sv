module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Continuous assignment for subtraction
    assign result = A - B;
    
    // Optimized overflow detection:
    // Overflow occurs when input signs differ and result sign matches B's sign
    assign overflow = (A[63] ^ B[63]) & (result[63] == B[63]);

endmodule