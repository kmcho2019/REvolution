module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Calculate the difference and check for borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction A - B and check for borrow
assign diff = A - B;
assign borrow = (A < B) ? 1'b1 : 1'b0;

// Determine the outputs based on the result and borrow
assign A_greater = (~borrow) && (diff != 4'b0);
assign A_equal = (~borrow) && (diff == 4'b0);
assign A_less = borrow;

endmodule