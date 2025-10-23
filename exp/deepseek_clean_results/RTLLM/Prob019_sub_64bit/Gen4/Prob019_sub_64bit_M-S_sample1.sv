module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Combined subtraction and overflow detection
    assign result = A - B;
    assign overflow = (~A[63] & B[63] & result[63]) |  // Positive overflow
                     (A[63] & ~B[63] & ~result[63]);   // Negative overflow

endmodule