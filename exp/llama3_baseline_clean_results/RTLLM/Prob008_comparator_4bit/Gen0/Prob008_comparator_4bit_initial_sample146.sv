module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signal to hold the result of subtraction
wire [3:0] diff;
// Internal signal to hold the borrow from subtraction
wire borrow;

// Perform subtraction A - B
assign diff = A - B;
// If borrow occurs, A is less than B
assign borrow = (A < B) ? 1'b1 : 1'b0;

// Determine the values of A_greater, A_equal, and A_less
assign A_greater = (~borrow && (diff != 4'b0000));
assign A_equal = (~borrow && (diff == 4'b0000));
assign A_less = borrow;

endmodule