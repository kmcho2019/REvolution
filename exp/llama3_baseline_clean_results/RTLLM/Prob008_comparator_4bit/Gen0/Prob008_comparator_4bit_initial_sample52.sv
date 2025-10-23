module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Perform subtraction: A - B
wire [3:0] diff;
wire borrow;

// Using a full subtractor for 4-bit subtraction
assign diff[0] = A[0] ^ B[0] ^ borrow;
assign diff[1] = A[1] ^ B[1] ^ borrow;
assign diff[2] = A[2] ^ B[2] ^ borrow;
assign diff[3] = A[3] ^ B[3] ^ borrow;

// Borrow generation
assign borrow = (~A[0] & B[0]) | (~A[1] & B[1] & ~borrow) | (~A[2] & B[2] & ~borrow) | (~A[3] & B[3] & ~borrow);

// Output logic
assign A_greater = (A[3] & ~B[3]) | (A[3] & B[3] & (A[2] & ~B[2])) | (A[3] & B[3] & B[2] & (A[1] & ~B[1])) | (A[3] & B[3] & B[2] & B[1] & (A[0] & ~B[0]));
assign A_equal = ~(A_greater | (~A[3] & B[3]));
assign A_less = ~A_greater & ~A_equal;

endmodule