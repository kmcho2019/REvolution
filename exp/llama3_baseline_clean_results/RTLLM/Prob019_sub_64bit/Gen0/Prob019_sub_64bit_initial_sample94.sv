module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    assign result = A - B;
    
    // Check for positive overflow: A is positive, B is negative, but result is negative
    // Check for negative overflow: A is negative, B is positive, but result is positive
    assign overflow = ((~A[63] & B[63] & result[63]) | (A[63] & ~B[63] & ~result[63]));

endmodule