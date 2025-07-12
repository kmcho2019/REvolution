module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Internal signals
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire [63:0] diff;
    wire diff_sign;
    
    // Subtraction operation
    assign diff = A - B;
    assign diff_sign = diff[63];
    assign result = diff;
    
    // Overflow conditions
    wire positive_overflow = ~A_sign & B_sign & diff_sign;
    wire negative_overflow = A_sign & ~B_sign & ~diff_sign;
    
    // Final overflow output
    assign overflow = positive_overflow | negative_overflow;

endmodule