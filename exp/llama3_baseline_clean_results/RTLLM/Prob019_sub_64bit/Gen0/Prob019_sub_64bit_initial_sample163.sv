module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Compute the result of subtraction
assign result = A - B;

// Determine the sign of A, B, and the result
wire A_sign = A[63];
wire B_sign = B[63];
wire result_sign = result[63];

// Detect overflow conditions
assign overflow = (A_sign == 1'b0 && B_sign == 1'b1 && result_sign == 1'b1) ||
                  (A_sign == 1'b1 && B_sign == 1'b0 && result_sign == 1'b0);

endmodule