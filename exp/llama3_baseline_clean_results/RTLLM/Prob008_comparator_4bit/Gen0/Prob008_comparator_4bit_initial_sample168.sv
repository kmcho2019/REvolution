module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals to hold the result of subtraction and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction (A - B) and generate borrow
assign diff[0] = A[0] - B[0];
assign borrow = (A[0] < B[0]);
assign diff[1] = A[1] - B[1] - borrow;
assign borrow = (A[1] < B[1]) || (borrow && (A[1] == B[1]));
assign diff[2] = A[2] - B[2] - borrow;
assign borrow = (A[2] < B[2]) || (borrow && (A[2] == B[2]));
assign diff[3] = A[3] - B[3] - borrow;

// Determine A_greater, A_equal, and A_less based on the result of subtraction and borrow
assign A_greater = (~borrow) && (|diff); // A is greater than B if no borrow and diff is non-zero
assign A_equal = (~borrow) && (~|diff); // A is equal to B if no borrow and diff is zero
assign A_less = borrow; // A is less than B if borrow occurs

endmodule