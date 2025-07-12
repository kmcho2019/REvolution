module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B and generate borrow
wire [3:0] diff;
wire borrow;

assign diff = A - B;
assign borrow = (A < B) ? 1 : 0;

// Assign values to output ports based on result and borrow
assign A_greater = (~borrow && diff != 0) ? 1 : 0;
assign A_equal = (diff == 0 && ~borrow) ? 1 : 0;
assign A_less = borrow ? 1 : 0;

endmodule