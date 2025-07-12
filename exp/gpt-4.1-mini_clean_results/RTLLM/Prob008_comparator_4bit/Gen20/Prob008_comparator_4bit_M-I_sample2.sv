module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Subtract B from A, 5-bit to capture borrow (MSB)
    wire [4:0] diff = {1'b0, A} - {1'b0, B};

    // If MSB (borrow) is 1, A < B
    wire borrow = diff[4];

    // Equality when lower 4 bits are zero
    wire equal = (diff[3:0] == 4'b0000);

    assign A_less    = borrow;
    assign A_equal   = equal;
    assign A_greater = (~borrow) & (~equal);

endmodule