module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B
wire [3:0] diff;
wire borrow;

// Full subtractor implementation
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign borrow = (~A[0] & B[0]) | (~A[0] & borrow) | (B[0] & borrow);

// Chain borrow for each bit
wire borrow1, borrow2, borrow3;
assign diff[1] = A[1] ^ B[1] ^ borrow1;
assign borrow1 = (~A[1] & B[1]) | (~A[1] & borrow) | (B[1] & borrow);
assign diff[2] = A[2] ^ B[2] ^ borrow2;
assign borrow2 = (~A[2] & B[2]) | (~A[2] & borrow1) | (B[2] & borrow1);
assign diff[3] = A[3] ^ B[3] ^ borrow3;
assign borrow3 = (~A[3] & B[3]) | (~A[3] & borrow2) | (B[3] & borrow2);

// Determine if A is greater than B
assign A_greater = ~borrow3 & (|diff); // |diff checks if any bit in diff is 1

// Determine if A is equal to B
assign A_equal = ~borrow3 & ~(|diff); // ~(|diff) checks if all bits in diff are 0

// Determine if A is less than B
assign A_less = borrow3;

endmodule