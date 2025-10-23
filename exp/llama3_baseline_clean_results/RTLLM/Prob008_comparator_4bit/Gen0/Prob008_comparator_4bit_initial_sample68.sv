module comparator_4bit(
    input  [3:0] A,    // First 4-bit input operand
    input  [3:0] B,    // Second 4-bit input operand
    output A_greater,  // Output indicating if A is greater than B
    output A_equal,    // Output indicating if A is equal to B
    output A_less      // Output indicating if A is less than B
);

    // Perform subtraction operation: A - B
    wire [3:0] diff;
    wire borrow;

    // Calculate the difference and borrow
    assign {borrow, diff} = A - {1'b0, B};

    // A is greater than B if no borrow occurs and the result of subtraction is non-zero
    assign A_greater = ~borrow & ~(|diff);

    // A is equal to B if the result of subtraction is zero
    assign A_equal = ~borrow & ~(|diff);

    // A is less than B if a borrow occurs during the subtraction
    assign A_less = borrow;

    // However, there's an issue with the above implementation: the conditions for A_greater and A_equal are identical, 
    // which means they can't be mutually exclusive. 
    // The condition for A_greater should be that the result is non-zero and no borrow occurred.
    // The condition for A_equal should be that the result is zero and no borrow occurred.
    // We correct this by redefining A_greater and A_equal.

    assign A_greater = ~borrow & (|diff);
    assign A_equal = ~borrow & ~( |diff );
    assign A_less = borrow;

endmodule