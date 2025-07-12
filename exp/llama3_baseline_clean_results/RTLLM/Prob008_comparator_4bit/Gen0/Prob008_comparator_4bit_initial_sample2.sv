module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Temporary signals for the subtraction result and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction and borrow calculation
assign {borrow, diff[3:0]} = A - B;

// Determine A_greater
assign A_greater = (borrow == 0) && (diff != 4'b0000);

// Determine A_equal
assign A_equal = (borrow == 0) && (diff == 4'b0000);

// Determine A_less
assign A_less = borrow;

endmodule