module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for borrow and result of subtraction
wire [3:0] diff;
wire borrow;

// Perform subtraction A - B
assign diff[0] = A[0] ^ B[0];
assign borrow = (~A[0] & B[0]);

// Propagate borrow and calculate difference for remaining bits
assign diff[1] = A[1] ^ B[1] ^ borrow;
assign borrow = (~A[1] & (B[1] ^ borrow)) | (borrow & (A[1] ^ B[1]));

assign diff[2] = A[2] ^ B[2] ^ borrow;
assign borrow = (~A[2] & (B[2] ^ borrow)) | (borrow & (A[2] ^ B[2]));

assign diff[3] = A[3] ^ B[3] ^ borrow;

// Determine outputs based on result of subtraction and borrow
assign A_greater = ~borrow & (|diff); // A > B if no borrow and diff is not zero
assign A_equal = ~borrow & ~(|diff); // A == B if no borrow and diff is zero
assign A_less = borrow; // A < B if borrow occurred

endmodule