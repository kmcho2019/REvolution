module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction operation: A - B
wire [3:0] diff;
wire borrow;

// Use a full subtractor for each bit
assign {borrow, diff[0]} = A[0] - B[0];
assign {diff[1]} = A[1] - B[1] - borrow;
assign {diff[2]} = A[2] - B[2] - diff[1];
assign {diff[3]} = A[3] - B[3] - diff[2];

// Determine the output based on the borrow and difference
assign A_less = borrow;
assign A_equal = ~(|diff); // A_equal is 1 if all bits of diff are 0
assign A_greater = ~(A_less | A_equal); // A_greater is 1 if A_less and A_equal are 0

endmodule