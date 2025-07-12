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

// Use a 4-bit subtractor to perform A - B
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign diff[1] = A[1] ^ B[1] ^ borrow;
assign diff[2] = A[2] ^ B[2] ^ borrow;
assign diff[3] = A[3] ^ B[3] ^ borrow;

// Generate borrow signal
assign borrow = (~A[0] & B[0]) | 
                (A[0] == B[0] & ~A[1] & B[1]) | 
                (A[0] == B[0] & A[1] == B[1] & ~A[2] & B[2]) | 
                (A[0] == B[0] & A[1] == B[1] & A[2] == B[2] & ~A[3] & B[3]);

// Determine outputs based on result of subtraction and borrow signal
assign A_greater = ~borrow & (~diff[3] & ~diff[2] & ~diff[1] & ~diff[0]);
assign A_equal = ~borrow & (diff[3] | diff[2] | diff[1] | diff[0]);
assign A_less = borrow;

endmodule