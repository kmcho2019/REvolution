module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for subtraction result and borrow flag
wire [3:0] diff;
wire borrow;

// Perform subtraction A - B
assign diff[0] = A[0] - B[0];
assign borrow = (B[0] > A[0]);
assign diff[1] = A[1] - B[1] - borrow;
wire borrow1 = (B[1] + borrow > A[1]);
assign diff[2] = A[2] - B[2] - borrow1;
wire borrow2 = (B[2] + borrow1 > A[2]);
assign diff[3] = A[3] - B[3] - borrow2;

// Determine comparison result based on subtraction result and borrow flag
assign A_less = borrow2;
assign A_equal = ~(diff[3] | diff[2] | diff[1] | diff[0] | borrow2);
assign A_greater = ~A_less & ~A_equal;

endmodule