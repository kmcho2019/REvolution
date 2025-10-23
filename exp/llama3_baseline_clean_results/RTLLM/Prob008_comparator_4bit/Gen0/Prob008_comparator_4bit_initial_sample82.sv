module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction operation A - B
wire [3:0] diff;
assign diff = A - B;

// Analyze the result of subtraction
assign A_greater = (diff[3] == 0) && (diff!= 4'b0000); // No borrow and non-zero result
assign A_equal = (diff == 4'b0000); // Zero result
assign A_less = (diff[3] == 1); // Borrow occurred

endmodule