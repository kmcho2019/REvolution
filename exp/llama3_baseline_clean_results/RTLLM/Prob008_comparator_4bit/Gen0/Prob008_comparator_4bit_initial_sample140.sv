module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction operation: A - B
wire [3:0] diff;
assign diff = A - B;

// Check if A is less than B (borrow occurred)
assign A_less = (B > A)? 1'b1 : 1'b0;

// Check if A is equal to B (result of subtraction is zero)
assign A_equal = (A == B)? 1'b1 : 1'b0;

// Check if A is greater than B (no borrow and result is non-zero)
assign A_greater = (A > B)? 1'b1 : 1'b0;

endmodule