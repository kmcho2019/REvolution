module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Shared sign bits
    wire A_sign = A[63];
    wire B_sign = B[63];
    
    // Direct subtraction
    assign result = A - B;
    
    // Optimized overflow detection
    assign overflow = (~A_sign & B_sign & result[63]) | 
                     (A_sign & ~B_sign & ~result[63]);

endmodule