module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

reg [3:0] result;
reg borrow;

// Perform bit-by-bit subtraction and generate borrow signal
assign result[0] = A[0] - B[0];
assign borrow = (A[0] < B[0]);
assign result[1] = A[1] - B[1] - borrow;
assign borrow = (A[1] < B[1]) || (A[1] == B[1] && borrow);
assign result[2] = A[2] - B[2] - borrow;
assign borrow = (A[2] < B[2]) || (A[2] == B[2] && borrow);
assign result[3] = A[3] - B[3] - borrow;

// Encode output signals
assign A_greater = ~borrow && (result[3] || result[2] || result[1] || result[0]);
assign A_equal = ~borrow && ~(|result);
assign A_less = borrow;

endmodule