module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Arithmetic comparison for borrow detection (A < B)
    wire [4:0] diff = {1'b0, A} - {1'b0, B};
    assign A_less = diff[4];  // Borrow bit indicates A < B

    // Parallel equality check
    assign A_equal = (A == B);

    // A > B when neither less nor equal
    assign A_greater = ~A_less & ~A_equal;

endmodule