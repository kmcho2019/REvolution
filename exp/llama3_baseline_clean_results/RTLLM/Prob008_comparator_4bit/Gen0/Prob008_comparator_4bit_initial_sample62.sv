module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B
wire [3:0] diff;
wire borrow;

// Subtract B from A, considering borrow
assign {borrow, diff} = A - B;

// Determine outputs based on subtraction result and borrow
assign A_less = borrow; // If borrow occurs, A is less than B
assign A_equal = ~borrow & (diff == 4'd0); // If no borrow and result is zero, A is equal to B
assign A_greater = ~borrow & (diff != 4'd0); // If no borrow and result is non-zero, A is greater than B

endmodule