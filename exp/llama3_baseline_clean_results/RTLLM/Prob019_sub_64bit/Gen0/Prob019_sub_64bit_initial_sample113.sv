module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform binary subtraction
assign result = A - B;

// Detect overflow conditions
// Positive overflow: A is positive, B is negative, result is negative
// Negative overflow: A is negative, B is positive, result is positive
assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) ||
                  (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0);

endmodule