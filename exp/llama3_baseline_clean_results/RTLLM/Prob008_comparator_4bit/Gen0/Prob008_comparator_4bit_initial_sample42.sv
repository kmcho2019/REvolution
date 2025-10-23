module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for borrow and result
wire [3:0] result;
wire [3:1] borrow;

// Full subtractor for bit 0
assign result[0] = A[0] ^ B[0] ^ borrow[1];
assign borrow[1] = (~A[0] & B[0]) | (borrow[2] & (A[0] ^ B[0]));

// Full subtractor for bit 1
assign result[1] = A[1] ^ B[1] ^ borrow[2];
assign borrow[2] = (~A[1] & B[1]) | (borrow[3] & (A[1] ^ B[1]));

// Full subtractor for bit 2
assign result[2] = A[2] ^ B[2] ^ borrow[3];
assign borrow[3] = (~A[2] & B[2]);

// Full subtractor for bit 3
assign result[3] = A[3] ^ B[3];

// Output logic
assign A_greater = ~borrow[1] & (|result); // A is greater than B if no borrow and result is non-zero
assign A_equal = ~borrow[1] & ~( |result); // A is equal to B if no borrow and result is zero
assign A_less = borrow[1]; // A is less than B if borrow occurs

endmodule