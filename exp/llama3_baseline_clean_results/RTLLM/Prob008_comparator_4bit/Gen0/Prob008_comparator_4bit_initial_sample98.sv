// Define the comparator_4bit module
module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Internal wires to store the result of subtraction and borrow signals
wire [3:0] result;
wire [3:0] borrow;

// Perform subtraction and generate borrow signals
assign result[0] = A[0] ^ B[0] ^ borrow[0];
assign borrow[1] = (A[0] & ~B[0]) | (~A[0] & B[0] & borrow[0]);
assign result[1] = A[1] ^ B[1] ^ borrow[1];
assign borrow[2] = (A[1] & ~B[1]) | (~A[1] & B[1] & borrow[1]);
assign result[2] = A[2] ^ B[2] ^ borrow[2];
assign borrow[3] = (A[2] & ~B[2]) | (~A[2] & B[2] & borrow[2]);
assign result[3] = A[3] ^ B[3] ^ borrow[3];

// Determine if A is less than B
assign A_less = borrow[3];

// Determine if A is equal to B
assign A_equal = ~(result[0] | result[1] | result[2] | result[3]);

// Determine if A is greater than B
assign A_greater = ~A_less & ~A_equal;

endmodule