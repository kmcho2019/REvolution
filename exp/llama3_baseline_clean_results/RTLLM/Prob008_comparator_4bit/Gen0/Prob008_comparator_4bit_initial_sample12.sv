module comparator_4bit(
    input [3:0] A, // First 4-bit input operand
    input [3:0] B, // Second 4-bit input operand
    output A_greater, // 1-bit output indicating if A is greater than B
    output A_equal, // 1-bit output indicating if A is equal to B
    output A_less // 1-bit output indicating if A is less than B
);

// Internal signals for borrow and result
wire [3:0] result;
wire borrow;

// Subtraction logic using full subtractors
assign result[0] = A[0] - B[0];
assign borrow = (A[0] < B[0]);
assign result[1] = A[1] - B[1] - borrow;
assign borrow = (A[1] < (B[1] + borrow));
assign result[2] = A[2] - B[2] - borrow;
assign borrow = (A[2] < (B[2] + borrow));
assign result[3] = A[3] - B[3] - borrow;

// Output logic
assign A_greater = ~borrow & ~(|result); // A > B if no borrow and result is not zero
assign A_equal = ~(|result) & borrow; // A == B if result is zero
assign A_less = borrow; // A < B if borrow

endmodule