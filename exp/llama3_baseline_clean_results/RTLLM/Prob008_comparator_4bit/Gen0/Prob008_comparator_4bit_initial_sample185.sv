module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less     // 1-bit output indicating if A is less than B
);

    wire [3:0] result;  // Result of subtraction A - B
    wire borrow;        // Borrow signal

    // Perform subtraction A - B
    assign {borrow, result} = A - B;

    // Determine comparison result based on borrow and result
    assign A_greater = (~borrow) && (result!= 4'b0);  // A is greater than B if no borrow and result is non-zero
    assign A_equal = (result == 4'b0) && (~borrow);    // A is equal to B if result is zero and no borrow
    assign A_less = borrow;                             // A is less than B if borrow occurs

endmodule