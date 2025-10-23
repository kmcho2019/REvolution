module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] diff;
    wire borrow;

    // Perform 4-bit subtraction A - B
    assign {borrow, diff} = A - B;

    // Generate comparison outputs
    assign A_equal = (diff == 4'b0000) && !borrow;
    assign A_greater = (diff != 4'b0000) && !borrow;
    assign A_less = borrow;

endmodule