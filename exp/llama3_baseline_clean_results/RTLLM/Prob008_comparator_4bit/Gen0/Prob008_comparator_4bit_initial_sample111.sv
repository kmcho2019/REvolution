module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for the result of subtraction and borrow
wire [3:0] diff;
wire borrow;

// Perform subtraction A - B
assign diff[0] = A[0] - B[0];
assign diff[1] = A[1] - B[1] - borrow;
assign diff[2] = A[2] - B[2] - borrow;
assign diff[3] = A[3] - B[3] - borrow;

// Generate borrow signal
assign borrow = (A[0] < B[0]) || ((A[0] == B[0]) && (A[1] < B[1])) || ((A[0:1] == B[0:1]) && (A[2] < B[2])) || ((A[0:2] == B[0:2]) && (A[3] < B[3]));

// Determine output signals based on comparison
assign A_greater = ~borrow && (|diff); // A is greater than B if no borrow and result is non-zero
assign A_equal = ~borrow && ~(|diff);  // A is equal to B if no borrow and result is zero
assign A_less = borrow;                // A is less than B if a borrow occurs

endmodule