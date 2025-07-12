module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less    // 1-bit output indicating if A is less than B
);

// Internal wires for the result of the subtraction operation
wire [3:0] diff;

// Perform the subtraction operation: A - B
assign diff[0] = A[0] ^ B[0] ^ (A[0] & B[0]);
assign diff[1] = A[1] ^ B[1] ^ (A[1] & B[1]);
assign diff[2] = A[2] ^ B[2] ^ (A[2] & B[2]);
assign diff[3] = A[3] ^ B[3] ^ (A[3] & B[3]);

// Determine if A is greater than B
assign A_greater = (diff[3] == 1) ? 1 : ((diff[3] == 0) && (diff[2] == 1 || diff[1] == 1 || diff[0] == 1)) ? 1 : 0;

// Determine if A is equal to B
assign A_equal = (diff[3:0] == 4'b0000) ? 1 : 0;

// Determine if A is less than B
assign A_less = (diff[3] == 0) ? ((diff[2] == 0 && diff[1] == 0 && diff[0] == 1) || (diff[2] == 0 && diff[1] == 1) || (diff[2] == 1)) ? 1 : 0 : 0;

endmodule