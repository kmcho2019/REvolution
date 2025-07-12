module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals to store the result of the subtraction and borrow
wire [3:0] diff;
wire borrow;

// Perform the subtraction operation
assign diff[0] = A[0] - B[0];
assign borrow = (A[0] < B[0]);
assign diff[1] = A[1] - B[1] - borrow;
assign borrow = (A[1] < B[1] + borrow);
assign diff[2] = A[2] - B[2] - borrow;
assign borrow = (A[2] < B[2] + borrow);
assign diff[3] = A[3] - B[3] - borrow;

// Determine the output based on the result of the subtraction and borrow
assign A_less = borrow;
assign A_equal = ~(diff[3] | diff[2] | diff[1] | diff[0] | borrow);
assign A_greater = ~A_equal & ~A_less;

endmodule