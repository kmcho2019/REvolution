module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction and generate borrow (or carry)
wire [3:0] diff;
wire borrow;

// Use a full subtractor for the MSB and half subtractors for the rest
assign {borrow, diff[3]} = A[3] - B[3];

// Generate borrow and difference for the rest of the bits
assign diff[2] = A[2] - B[2] + borrow;
assign diff[1] = A[1] - B[1] + borrow;
assign diff[0] = A[0] - B[0] + borrow;

// Determine the output based on the result and borrow
assign A_greater = (~borrow) && (|diff);
assign A_equal = (~borrow) && (~|diff);
assign A_less = borrow;

endmodule