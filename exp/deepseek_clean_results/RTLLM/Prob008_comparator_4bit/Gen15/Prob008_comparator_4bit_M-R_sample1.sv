module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Arithmetic comparison approach
    wire [4:0] diff = {1'b0, A} - {1'b0, B};
    wire equal = (A == B);
    wire less = diff[4]; // Borrow indicates A < B

    // Output assignments - mutually exclusive
    assign A_equal = equal;
    assign A_less = less & ~equal;
    assign A_greater = ~equal & ~less;

endmodule