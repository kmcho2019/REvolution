module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] diff; // Difference between A and B
wire borrow;    // Borrow signal to check if A is less than B

// 4-bit subtractor implementation
assign diff[0] = A[0] - B[0];
assign diff[1] = A[1] - B[1];
assign diff[2] = A[2] - B[2];
assign diff[3] = A[3] - B[3];

// Calculate borrow signal
assign borrow = (A[0] < B[0]) | ((A[0] == B[0]) & (A[1] < B[1])) | 
                ((A[0] == B[0]) & (A[1] == B[1]) & (A[2] < B[2])) | 
                ((A[0] == B[0]) & (A[1] == B[1]) & (A[2] == B[2]) & (A[3] < B[3]));

// Determine A_greater, A_equal, A_less signals
assign A_greater = ~(borrow) & ~(diff[3] == 0 & diff[2] == 0 & diff[1] == 0 & diff[0] == 0);
assign A_equal = ~(borrow) & (diff[3] == 0 & diff[2] == 0 & diff[1] == 0 & diff[0] == 0);
assign A_less = borrow;

endmodule