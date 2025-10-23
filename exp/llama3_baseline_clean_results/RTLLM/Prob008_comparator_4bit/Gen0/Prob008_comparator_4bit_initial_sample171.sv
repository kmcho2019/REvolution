module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform bit-level subtraction operation: A - B
// and generate borrow signals
wire [3:0] diff;
wire borrow;

// Most significant bit (MSB) subtraction
assign diff[3] = A[3] ^ B[3] ^ borrow;
assign borrow = ~(A[3] ^ B[3]);

// Other bits subtraction
assign diff[2] = A[2] ^ B[2] ^ borrow;
assign borrow = ~(A[2] ^ B[2]) & (~A[3] ^ B[3]);

assign diff[1] = A[1] ^ B[1] ^ borrow;
assign borrow = ~(A[1] ^ B[1]) & (~A[2] ^ B[2]) & (~A[3] ^ B[3]);

assign diff[0] = A[0] ^ B[0] ^ borrow;
assign borrow = ~(A[0] ^ B[0]) & (~A[1] ^ B[1]) & (~A[2] ^ B[2]) & (~A[3] ^ B[3]);

// Generate comparison outputs
assign A_greater = ~borrow & (|diff);  // A greater than B
assign A_equal = ~borrow & ~(|diff);   // A equal to B
assign A_less = borrow;                // A less than B

endmodule