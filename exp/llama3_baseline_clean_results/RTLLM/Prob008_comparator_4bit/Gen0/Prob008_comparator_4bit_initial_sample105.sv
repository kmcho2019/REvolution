module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [3:0] diff;
    wire borrow;

    assign {borrow, diff[3:0]} = A - B;

    assign A_greater = (~borrow) & (|diff);  // A is greater than B if no borrow and result is non-zero
    assign A_equal = ~borrow & ~( |diff );  // A is equal to B if no borrow and result is zero
    assign A_less = borrow;  // A is less than B if borrow occurs

endmodule