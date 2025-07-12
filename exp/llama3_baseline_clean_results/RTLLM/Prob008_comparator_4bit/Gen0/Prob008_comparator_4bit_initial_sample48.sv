module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction operation A - B
wire [3:0] result;
wire borrow;

// Subtraction logic
assign result[0] = A[0] ^ B[0] ^ borrow;
assign result[1] = A[1] ^ B[1] ^ borrow;
assign result[2] = A[2] ^ B[2] ^ borrow;
assign result[3] = A[3] ^ B[3] ^ borrow;

assign borrow = (A[0] < B[0]) | (A[1] < B[1]) | (A[2] < B[2]) | (A[3] < B[3]);

// Output logic
assign A_greater = (~borrow) & (~(|result));  // A greater than B if no borrow and result is non-zero
assign A_equal = (~borrow) & (~(|result));   // A equal to B if no borrow and result is zero
assign A_less = borrow;                       // A less than B if borrow occurs

endmodule