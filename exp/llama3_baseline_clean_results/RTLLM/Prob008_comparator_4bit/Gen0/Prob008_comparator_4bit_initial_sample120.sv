module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less    // 1-bit output indicating if A is less than B
);

// Internal signals for borrow and result
wire [3:0] result;
wire [3:0] borrow;

// Perform subtraction and generate borrow signals
assign {borrow[3], result[3]} = A[3] - B[3];
assign {borrow[2], result[2]} = A[2] - B[2] - borrow[3];
assign {borrow[1], result[1]} = A[1] - B[1] - borrow[2];
assign {borrow[0], result[0]} = A[0] - B[0] - borrow[1];

// Determine A_greater, A_equal, A_less based on borrow and result
assign A_greater = ~borrow[3] & (|result);
assign A_equal = ~(|result) & ~borrow[3];
assign A_less = borrow[3];

endmodule