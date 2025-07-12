module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B
wire [3:0] diff;
assign diff = A - B;

// Check for borrow (carry-out) during subtraction
wire borrow;
assign borrow = (A < B) ? 1'b1 : 1'b0;

// Determine comparison results
assign A_greater = (~borrow) & (diff != 4'b0);
assign A_equal = (diff == 4'b0) & (~borrow);
assign A_less = borrow;

endmodule