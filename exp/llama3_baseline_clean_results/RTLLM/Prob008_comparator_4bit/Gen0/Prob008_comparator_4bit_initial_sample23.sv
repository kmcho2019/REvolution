module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires to hold the result of subtraction and borrow
wire [3:0] result;
wire borrow;

// Perform subtraction A - B by adding A with 2's complement of B
assign result[0] = A[0] ^ B[0] ^ 1; // Bit-level XOR and then XOR with 1 (to add 1)
assign result[1] = A[1] ^ B[1] ^ (A[0] & B[0]); // Bit-level XOR and then XOR with carry from previous bit
assign result[2] = A[2] ^ B[2] ^ (A[1] & B[1]); // Bit-level XOR and then XOR with carry from previous bit
assign result[3] = A[3] ^ B[3] ^ (A[2] & B[2]); // Bit-level XOR and then XOR with carry from previous bit

// Determine borrow
assign borrow = (A[0] & B[0]) | (A[1] & B[1]) | (A[2] & B[2]);

// Set outputs based on result and borrow
assign A_greater = (~borrow) & (~result[3]); // A is greater than B if no borrow and MSB of result is 0
assign A_equal = (~borrow) & result[3]; // A is equal to B if no borrow and MSB of result is 1
assign A_less = borrow; // A is less than B if borrow occurred

endmodule