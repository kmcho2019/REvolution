module comparator_4bit(
    input  [3:0] A,  // First 4-bit input operand
    input  [3:0] B,  // Second 4-bit input operand
    output       A_greater,  // 1-bit output indicating if A is greater than B
    output       A_equal,    // 1-bit output indicating if A is equal to B
    output       A_less      // 1-bit output indicating if A is less than B
);

// Internal signal to hold the result of subtraction
wire [3:0] result;
// Internal signal to track borrow (A is less than B)
wire       borrow;

// Perform subtraction A - B
assign result = A - B;

// If no borrow and result is non-zero, A is greater than B
assign A_greater = (result[3] == 0) && (|result);  // result is non-zero and no borrow

// If result is zero, A is equal to B
assign A_equal = ~(|result);  // result is zero

// If borrow occurs during subtraction, A is less than B
assign borrow = (A[3] == 0) && (B[3] == 1);  // simplified condition for borrow
assign A_less = borrow || (result[3] == 1);  // either borrow or result is negative

endmodule