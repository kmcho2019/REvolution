module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform the subtraction
assign result = A - B;

// Determine the signs of A, B, and the result
wire sign_A = A[63];
wire sign_B = B[63];
wire sign_result = result[63];

// Check for overflow conditions
assign overflow = (sign_A == 0 && sign_B == 1 && sign_result == 1) || 
                  (sign_A == 1 && sign_B == 0 && sign_result == 0);

endmodule