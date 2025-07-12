module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

    // Internal wires to store borrow and difference
    wire [3:0] diff;
    wire borrow;

    // Perform subtraction A - B
    // Assuming A and B are unsigned, use bit-level subtraction and borrow
    assign diff[0] = A[0] ^ B[0] ^ borrow;
    assign borrow = (A[0] == 1'b0 && B[0] == 1'b1) || (diff[0] == 1'b0 && B[0] == 1'b1);

    // Higher bits need to consider the borrow from previous bit
    assign diff[1] = A[1] ^ B[1] ^ borrow;
    assign borrow = (A[1] == 1'b0 && B[1] == 1'b1) || (diff[1] == 1'b0 && B[1] == 1'b1);

    assign diff[2] = A[2] ^ B[2] ^ borrow;
    assign borrow = (A[2] == 1'b0 && B[2] == 1'b1) || (diff[2] == 1'b0 && B[2] == 1'b1);

    assign diff[3] = A[3] ^ B[3] ^ borrow;

    // Determine the final outputs based on borrow and difference
    // A is less than B if a borrow occurred
    assign A_less = borrow;

    // A equals B if no borrow and difference is zero
    assign A_equal = ~borrow && (~diff[3] && ~diff[2] && ~diff[1] && ~diff[0]);

    // A is greater than B if no borrow and difference is not zero
    assign A_greater = ~borrow && (diff[3] || diff[2] || diff[1] || diff[0]);

endmodule