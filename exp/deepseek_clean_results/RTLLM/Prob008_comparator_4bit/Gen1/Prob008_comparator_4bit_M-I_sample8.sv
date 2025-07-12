module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire borrow;
    wire equal;

    // Efficient equality check
    assign equal = (A == B);

    // Borrow generation for A < B
    assign borrow = (A < B);

    // Output assignments
    assign A_equal = equal;
    assign A_less = borrow;
    assign A_greater = ~borrow & ~equal;

endmodule