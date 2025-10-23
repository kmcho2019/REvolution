module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Sign-extended subtraction (5 bits to catch borrow)
    wire [4:0] diff = {1'b0, A} - {1'b0, B};

    assign A_less = diff[4];       // Borrow indicates A < B
    assign A_equal = (diff[3:0] == 4'b0);
    assign A_greater = ~A_less & ~A_equal;

endmodule