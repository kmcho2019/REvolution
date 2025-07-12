module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] diff;
wire borrow;

// Perform subtraction A - B
full_subtractor fs0(A[0], B[0], 1'b0, diff[0], borrow);
full_subtractor fs1(A[1], B[1], borrow, diff[1], borrow);
full_subtractor fs2(A[2], B[2], borrow, diff[2], borrow);
full_subtractor fs3(A[3], B[3], borrow, diff[3], borrow);

// Determine A_greater, A_equal, A_less based on the result of the subtraction
assign A_greater = (~borrow) & (~(|diff)); // No borrow and result is non-zero
assign A_equal = (~borrow) & (~(|diff)); // No borrow and result is zero
assign A_less = borrow; // Borrow occurred during subtraction

// Since A_greater and A_equal cannot be true at the same time, use a decoder
// to ensure mutual exclusivity
assign A_greater = ~A_less & ~A_equal;
assign A_equal = ~(A_greater | A_less);

endmodule

module full_subtractor(
    input a,
    input b,
    input borrow_in,
    output diff,
    output borrow
);

assign diff = a ^ b ^ borrow_in;
assign borrow = (~a & (b | borrow_in));

endmodule