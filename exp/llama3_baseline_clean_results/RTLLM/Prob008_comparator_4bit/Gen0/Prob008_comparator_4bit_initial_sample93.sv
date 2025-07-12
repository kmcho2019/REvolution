module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less     // 1-bit output indicating if A is less than B
);

    // Internal wires to store the result of subtraction
    wire [3:0] diff;
    wire borrow;

    // Perform subtraction (A - B) and check for borrow
    assign {borrow, diff} = A - B;

    // Determine A_greater
    assign A_greater = (~borrow) & (~(|diff));

    // Determine A_equal
    assign A_equal = ~(borrow | |diff);

    // Determine A_less
    assign A_less = borrow;

endmodule