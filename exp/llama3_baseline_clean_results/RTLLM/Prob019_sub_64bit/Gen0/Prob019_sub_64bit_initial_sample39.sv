module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Calculate the result of A - B
assign result = A - B;

// Determine the sign of A, B, and result
wire A_sign = A[63];
wire B_sign = B[63];
wire result_sign = result[63];

// Check for overflow conditions
assign overflow = (A_sign == 0 && B_sign == 1 && result_sign == 1) ||
                  (A_sign == 1 && B_sign == 0 && result_sign == 0);

endmodule