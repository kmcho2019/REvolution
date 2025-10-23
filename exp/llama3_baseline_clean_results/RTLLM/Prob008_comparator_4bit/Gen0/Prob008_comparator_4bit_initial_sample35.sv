module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less     // 1-bit output indicating if A is less than B
);

// Internal signals for the subtraction operation
wire [3:0] diff;
wire borrow;

// Perform the subtraction operation (A - B)
assign diff[0] = A[0] - B[0];
assign diff[1] = A[1] - B[1] - borrow;
assign diff[2] = A[2] - B[2] - borrow;
assign diff[3] = A[3] - B[3] - borrow;

// Generate the borrow signal
assign borrow = (A[0] < B[0]) || (A[1] < B[1] && A[0] == B[0]) || (A[2] < B[2] && A[1:0] == B[1:0]) || (A[3] < B[3] && A[2:0] == B[2:0]);

// Generate the output signals
assign A_greater = (diff[3:0] > 0) && !borrow;
assign A_equal = (diff[3:0] == 0) && !borrow;
assign A_less = borrow;

endmodule