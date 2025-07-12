module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] diff;
    wire borrow;

    // Perform subtraction A - B and generate borrow
    assign {borrow, diff[3:0]} = A - B;

    // If borrow occurs, A is less than B
    assign A_less = borrow;

    // If no borrow occurs and difference is non-zero, A is greater than B
    assign A_greater = ~borrow & ~(|diff);

    // If A and B are equal, the result of subtraction is zero
    assign A_equal = ~borrow & ~(|diff);

endmodule