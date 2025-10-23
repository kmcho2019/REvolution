module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals to hold the result of subtraction and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction A - B
assign {borrow, diff[3:0]} = A - B;

// Determine A_greater: If no borrow and difference is not zero
assign A_greater = ~(borrow) & ~(|diff);

// Determine A_equal: If difference is zero and no borrow
assign A_equal = ~(borrow) & ~(|diff);

// Determine A_less: If borrow occurs
assign A_less = borrow;

// However, the previous assignments do not correctly implement the logic as described.
// A_greater should be set when the difference is not zero and there's no borrow.
// A_equal should be set when the difference is zero, regardless of the borrow (since borrow in this context doesn't apply directly to equality).
// A_less should be set when there is a borrow.

// Corrected assignments:
assign A_greater = (~borrow) & (|diff); // Corrected logic
assign A_equal = ~(|diff); // Equality doesn't depend on borrow
assign A_less = borrow; // Directly set A_less if there's a borrow

endmodule