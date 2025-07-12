module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction A - B and check for borrow
    wire [3:0] diff;
    assign diff = A - B;

    // Determine if A is greater than B (no borrow and result is non-zero)
    assign A_greater = (A >= B) && (A!= B);

    // Determine if A is equal to B (result of subtraction is zero)
    assign A_equal = A == B;

    // Determine if A is less than B (borrow occurs during subtraction)
    assign A_less = A < B;

endmodule