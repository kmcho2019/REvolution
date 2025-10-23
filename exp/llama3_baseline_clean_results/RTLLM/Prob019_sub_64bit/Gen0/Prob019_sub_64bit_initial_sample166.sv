module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform binary subtraction to obtain the result
assign result = A - B;

// Detect overflow conditions by examining the sign bits of A, B, and the result
assign overflow = (A[63] == 0 && B[63] == 1 && result[63] == 1) || (A[63] == 1 && B[63] == 0 && result[63] == 0);

endmodule