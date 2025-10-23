module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform the subtraction operation
assign result = A - B;

// Determine the sign of A, B, and the result
wire sign_A = A[63];
wire sign_B = B[63];
wire sign_result = result[63];

// Check for overflow conditions
assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_result == 1'b1) || 
                  (sign_A == 1'b1 && sign_B == 1'b0 && sign_result == 1'b0);

endmodule