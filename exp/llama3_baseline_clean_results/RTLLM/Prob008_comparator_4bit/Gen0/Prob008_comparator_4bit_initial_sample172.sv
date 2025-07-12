module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction and generate borrow
wire [3:0] diff;
wire borrow;

assign diff[0] = A[0] - B[0];
assign diff[1] = A[1] - B[1] - borrow;
assign diff[2] = A[2] - B[2] - borrow;
assign diff[3] = A[3] - B[3] - borrow;

// Generate borrow
assign borrow = (A[0] < B[0]) | ((A[0] == B[0]) & (A[1] < B[1])) | ((A[0] == B[0]) & (A[1] == B[1]) & (A[2] < B[2])) | ((A[0] == B[0]) & (A[1] == B[1]) & (A[2] == B[2]) & (A[3] < B[3]));

// Determine outputs based on result and borrow
assign A_greater = ~borrow & (|diff);
assign A_equal = ~borrow & ~(|diff);
assign A_less = borrow;

endmodule