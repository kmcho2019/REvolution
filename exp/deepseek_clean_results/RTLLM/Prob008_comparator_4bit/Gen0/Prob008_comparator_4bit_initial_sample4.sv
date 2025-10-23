module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] diff;
    wire borrow;

    // Perform 4-bit subtraction with borrow propagation
    assign {borrow, diff} = A - B;

    // Generate outputs
    assign A_equal = (diff == 4'b0000) && (borrow == 0);
    assign A_greater = (diff != 4'b0000) && (borrow == 0);
    assign A_less = (borrow == 1);

endmodule