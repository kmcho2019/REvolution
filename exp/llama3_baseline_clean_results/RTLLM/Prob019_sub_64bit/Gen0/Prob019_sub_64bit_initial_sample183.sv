module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform subtraction
assign result = A - B;

// Detect overflow
// Check if A is positive and B is negative and result is negative
// or if A is negative and B is positive and result is positive
assign overflow = ((~A[63] & B[63] & result[63]) | (A[63] & ~B[63] & ~result[63]));

endmodule