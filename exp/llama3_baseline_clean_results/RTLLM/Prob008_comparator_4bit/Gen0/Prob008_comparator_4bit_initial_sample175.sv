module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for borrow and result
wire [3:0] result;
wire [3:1] borrow;

// Full subtractor for bit 0
assign result[0] = A[0] ^ B[0] ^ borrow[1];
assign borrow[1] = (A[0] & B[0]) | (A[0] & borrow[1]) | (B[0] & borrow[1]);

// Full subtractor for bit 1
assign result[1] = A[1] ^ B[1] ^ borrow[2];
assign borrow[2] = (A[1] & B[1]) | (A[1] & borrow[2]) | (B[1] & borrow[2]);

// Full subtractor for bit 2
assign result[2] = A[2] ^ B[2] ^ borrow[3];
assign borrow[3] = (A[2] & B[2]) | (A[2] & borrow[3]) | (B[2] & borrow[3]);

// Full subtractor for bit 3
assign result[3] = A[3] ^ B[3];

// Determine if A is less than B
assign A_less = borrow[1] | borrow[2] | borrow[3];

// Determine if A is equal to B
assign A_equal = ~(result[0] | result[1] | result[2] | result[3]);

// Determine if A is greater than B
assign A_greater = ~A_less & ~A_equal;

endmodule