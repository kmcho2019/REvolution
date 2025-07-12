module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Internal wires to store the result of subtraction and borrow
    wire [3:0] diff;
    wire borrow;

    // Perform subtraction A - B
    assign {borrow, diff[3:0]} = A - B;

    // Set outputs based on comparison result
    assign A_greater = (borrow == 0) && (diff!= 4'b0000);
    assign A_equal = (diff == 4'b0000) && (borrow == 0);
    assign A_less = borrow == 1;

endmodule