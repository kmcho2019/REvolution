module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    // Perform the subtraction
    assign result = A - B;

    // Detect overflow by examining the sign bits of A, B, and the result
    // Overflow occurs when (A is positive and B is negative and result is negative) or (A is negative and B is positive and result is positive)
    assign overflow = ((~A[63] && B[63] && result[63]) || (A[63] && ~B[63] && ~result[63]));

endmodule