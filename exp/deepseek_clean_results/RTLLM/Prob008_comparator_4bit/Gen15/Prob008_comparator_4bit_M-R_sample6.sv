module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Subtraction result (4-bit + borrow)
    wire [4:0] diff = {1'b0, A} - {1'b0, B};

    // Output assignments
    assign A_equal = (A == B);
    assign A_less = diff[4];  // Borrow bit indicates A < B
    assign A_greater = ~A_equal & ~A_less;  // Neither equal nor less

endmodule