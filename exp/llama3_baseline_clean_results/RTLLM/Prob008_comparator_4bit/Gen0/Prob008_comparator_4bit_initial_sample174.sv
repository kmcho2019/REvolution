module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal wires for the subtraction result and borrow
wire [3:0] diff;
wire [3:0] borrow;

// Perform the subtraction A - B using full subtractors
full_subtractor fs3(A[3], B[3], 1'b0, diff[3], borrow[3]);
full_subtractor fs2(A[2], B[2], borrow[3], diff[2], borrow[2]);
full_subtractor fs1(A[1], B[1], borrow[2], diff[1], borrow[1]);
full_subtractor fs0(A[0], B[0], borrow[1], diff[0], borrow[0]);

// Determine the comparison results based on the borrow and difference
assign A_less = borrow[0];
assign A_equal = (~borrow[0]) & (~|diff); // diff is zero and no borrow
assign A_greater = (~borrow[0]) & (|diff); // diff is not zero and no borrow

endmodule

// Full subtractor module for a single bit
module full_subtractor(a, b, borrow_in, diff, borrow_out);
    input a, b, borrow_in;
    output diff, borrow_out;

    assign diff = a ^ b ^ borrow_in;
    assign borrow_out = (~a & b) | (borrow_in & (~a)) | (borrow_in & b);

endmodule