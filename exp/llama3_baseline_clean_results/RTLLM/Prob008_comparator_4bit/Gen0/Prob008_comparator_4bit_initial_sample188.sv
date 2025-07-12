module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for subtraction result and borrow
wire [3:0] diff;
wire borrow_out;

// Perform subtraction (A - B) using full subtractors
full_subtractor fs0(A[0], B[0], 1'b0, diff[0], borrow_out);
full_subtractor fs1(A[1], B[1], borrow_out, diff[1], borrow_out);
full_subtractor fs2(A[2], B[2], borrow_out, diff[2], borrow_out);
full_subtractor fs3(A[3], B[3], borrow_out, diff[3], borrow_out);

// Determine A_greater, A_equal, A_less based on subtraction result and borrow
assign A_greater = (~borrow_out) && (|diff); // A > B if no borrow and diff is not zero
assign A_equal = (~borrow_out) && (~|diff); // A == B if no borrow and diff is zero
assign A_less = borrow_out; // A < B if borrow

endmodule

// Full subtractor module for a single bit
module full_subtractor(
    input a,
    input b,
    input borrow_in,
    output diff,
    output borrow_out
);

assign diff = a ^ b ^ borrow_in;
assign borrow_out = (~a && b) || (borrow_in && (~a ^ b));

endmodule