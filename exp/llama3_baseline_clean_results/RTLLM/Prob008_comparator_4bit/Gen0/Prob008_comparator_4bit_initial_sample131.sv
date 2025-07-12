module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for subtraction and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction
assign {borrow, diff} = A - B;

// Determine if A is greater than B
assign A_greater = (borrow == 0) && (diff != 0);

// Determine if A is equal to B
assign A_equal = (borrow == 0) && (diff == 0);

// Determine if A is less than B
assign A_less = borrow;

endmodule