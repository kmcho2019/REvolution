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

// Subtract B from A
assign {borrow, diff[3:0]} = A - B;

// Check if A is less than B (borrow occurred)
assign A_less = borrow;

// Check if A is equal to B (result is zero)
assign A_equal = (diff == 4'b0000) &&!borrow;

// Check if A is greater than B (no borrow and result is not zero)
assign A_greater =!borrow && (diff!= 4'b0000);

endmodule