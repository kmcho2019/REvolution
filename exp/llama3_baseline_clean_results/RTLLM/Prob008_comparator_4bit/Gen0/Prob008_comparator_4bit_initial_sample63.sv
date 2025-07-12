// 4-bit comparator module
module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,  // 1-bit output indicating if A is equal to B
    output A_less  // 1-bit output indicating if A is less than B
);

// Internal wires for the borrow and result of subtraction
wire [3:0] diff;
wire borrow;

// Perform subtraction A - B using full subtractors
full_subtractor fs0(A[0], B[0], 1'b0, diff[0], borrow);
full_subtractor fs1(A[1], B[1], borrow, diff[1], borrow);
full_subtractor fs2(A[2], B[2], borrow, diff[2], borrow);
full_subtractor fs3(A[3], B[3], borrow, diff[3], borrow);

// Determine if A is less than B (borrow occurred)
assign A_less = borrow;

// Determine if A is equal to B (result of subtraction is zero)
assign A_equal = ~(diff[0] | diff[1] | diff[2] | diff[3]);

// Determine if A is greater than B (no borrow and result is non-zero)
assign A_greater = ~borrow & (diff[0] | diff[1] | diff[2] | diff[3]);

// Full subtractor module
module full_subtractor(
    input a,  // Minuend
    input b,  // Subtrahend
    input borrow_in,  // Borrow in
    output diff,  // Difference
    output borrow_out  // Borrow out
);
    assign diff = a ^ b ^ borrow_in;
    assign borrow_out = (~a & b) | (borrow_in & (~a | b));
endmodule

endmodule