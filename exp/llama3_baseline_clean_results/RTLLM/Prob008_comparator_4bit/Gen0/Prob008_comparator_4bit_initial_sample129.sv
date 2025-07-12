module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction: A - B
wire [3:0] diff;
assign diff = A - B;

// Determine if A is greater than B (no borrow and diff is non-zero)
assign A_greater = (diff[3] == 0 && diff != 4'b0000);

// Determine if A is equal to B (diff is zero)
assign A_equal = (diff == 4'b0000);

// Determine if A is less than B (borrow occurs)
assign A_less = (diff[3] == 1);

endmodule