module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction operation
wire [3:0] diff;
assign diff = A - B;

// Check for borrow (A less than B)
assign A_less = (A < B)? 1'b1 : 1'b0;

// Check for equality (A equal to B)
assign A_equal = (A == B)? 1'b1 : 1'b0;

// Check for A greater than B
assign A_greater = (A > B)? 1'b1 : 1'b0;

endmodule