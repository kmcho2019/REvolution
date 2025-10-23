module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B using full subtractors
wire [3:0] diff;
wire borrow;

// Full subtractor for bit 0
wire diff_0, borrow_1;
full_subtractor fs_0(A[0], B[0], 1'b0, diff_0, borrow_1);

// Full subtractor for bit 1
wire diff_1, borrow_2;
full_subtractor fs_1(A[1], B[1], borrow_1, diff_1, borrow_2);

// Full subtractor for bit 2
wire diff_2, borrow_3;
full_subtractor fs_2(A[2], B[2], borrow_2, diff_2, borrow_3);

// Full subtractor for bit 3
wire diff_3, borrow_out;
full_subtractor fs_3(A[3], B[3], borrow_3, diff_3, borrow_out);

assign diff = {diff_3, diff_2, diff_1, diff_0};

// Determine the relationship between A and B based on the borrow and result
assign A_greater = ~borrow_out & ~(|diff);
assign A_equal = ~(|diff) & borrow_out;
assign A_less = borrow_out;

// Define the full subtractor module
module full_subtractor(
    input a,
    input b,
    input borrow_in,
    output diff,
    output borrow_out
);

assign diff = a ^ b ^ borrow_in;
assign borrow_out = (~a & b) | (~a & borrow_in) | (b & borrow_in);

endmodule

endmodule