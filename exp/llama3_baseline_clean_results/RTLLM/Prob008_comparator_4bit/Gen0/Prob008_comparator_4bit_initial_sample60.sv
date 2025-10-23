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

// Calculate the difference and borrow
assign {borrow, diff[3:0]} = A - B;

// Determine if A is greater than B
assign A_greater = (~borrow) & (~(|diff));

// Determine if A is equal to B
assign A_equal = ~borrow & ~(|diff);

// Determine if A is less than B
assign A_less = borrow;

endmodule