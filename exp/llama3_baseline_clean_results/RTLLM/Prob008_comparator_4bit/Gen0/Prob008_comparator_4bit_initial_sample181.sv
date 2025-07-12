module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction: A - B and generate borrow
wire [3:0] diff;
wire borrow;

// Full subtractor for each bit
assign {borrow, diff[0]} = A[0] - B[0];
assign diff[1] = A[1] - B[1] - borrow;
assign diff[2] = A[2] - B[2] - borrow;
assign diff[3] = A[3] - B[3] - borrow;

// Determine if A is greater than B
assign A_greater = (~borrow) & (|diff);

// Determine if A is equal to B
assign A_equal = ~borrow & ~(|diff);

// Determine if A is less than B
assign A_less = borrow;

endmodule