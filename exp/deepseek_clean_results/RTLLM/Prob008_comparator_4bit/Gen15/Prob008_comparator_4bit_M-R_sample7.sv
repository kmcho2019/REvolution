module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Subtraction with borrow detection
    wire [4:0] diff = {1'b0, A} - {1'b0, B};
    wire borrow = diff[4];  // Borrow indicates A < B

    // Output assignments
    assign A_equal = (A == B);
    assign A_greater = ~borrow & ~A_equal;
    assign A_less = borrow;

endmodule