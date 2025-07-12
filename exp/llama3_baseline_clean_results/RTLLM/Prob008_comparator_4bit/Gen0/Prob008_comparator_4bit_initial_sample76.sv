module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B
wire [3:0] diff;
wire borrow;

// Subtract B from A and generate borrow signal
full_subtractor fs0(A[0], B[0], 1'b0, diff[0], borrow);
full_subtractor fs1(A[1], B[1], borrow, diff[1], borrow);
full_subtractor fs2(A[2], B[2], borrow, diff[2], borrow);
full_subtractor fs3(A[3], B[3], borrow, diff[3], borrow);

// Determine if A is greater than B
assign A_greater = (~borrow) & (|diff);

// Determine if A is equal to B
assign A_equal = (~borrow) & (~|diff);

// Determine if A is less than B
assign A_less = borrow;

endmodule

// Full subtractor module
module full_subtractor(
    input a,
    input b,
    input borrow_in,
    output diff,
    output borrow_out
);

assign diff = a ^ b ^ borrow_in;
assign borrow_out = (b & ~a) | (b & borrow_in) | (~a & borrow_in);

endmodule