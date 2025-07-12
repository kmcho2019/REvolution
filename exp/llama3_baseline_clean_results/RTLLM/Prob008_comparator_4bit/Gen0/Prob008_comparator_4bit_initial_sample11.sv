module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction (A - B) and observe the borrow to determine the relationship
wire [3:0] diff;
wire borrow;

// Calculate the difference (A - B) considering borrow
assign {borrow, diff} = A - B;

// Set outputs based on the result of subtraction and borrow
assign A_greater = ~borrow & (|diff); // If no borrow and result is non-zero, A is greater
assign A_equal = ~borrow & ~( |diff); // If no borrow and result is zero, A is equal to B
assign A_less = borrow; // If borrow occurs, A is less than B

endmodule