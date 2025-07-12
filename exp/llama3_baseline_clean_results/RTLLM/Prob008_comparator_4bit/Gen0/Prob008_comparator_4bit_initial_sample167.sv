module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction: A - B
wire [3:0] diff;
wire borrow;

// 4-bit subtractor module
subtractor_4bit sub(
   .A(A),
   .B(B),
   .diff(diff),
   .borrow(borrow)
);

// Determine the outputs based on the result of subtraction and borrow
assign A_greater = (~borrow) & (~(|diff)); // A_greater is set if no borrow and result is not zero
assign A_equal = (~borrow) & (|diff) == 1'b0; // A_equal is set if no borrow and result is zero
assign A_less = borrow; // A_less is set if borrow occurs

endmodule

// 4-bit subtractor module
module subtractor_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] diff,
    output borrow
);

// Perform bit-level subtraction
assign diff[0] = A[0] - B[0];
assign diff[1] = A[1] - B[1];
assign diff[2] = A[2] - B[2];
assign diff[3] = A[3] - B[3];

// Generate borrow
assign borrow = (B[0] > A[0]) | 
                ((B[0] == A[0]) & (B[1] > A[1])) | 
                ((B[0] == A[0]) & (B[1] == A[1]) & (B[2] > A[2])) | 
                ((B[0] == A[0]) & (B[1] == A[1]) & (B[2] == A[2]) & (B[3] > A[3]));

endmodule