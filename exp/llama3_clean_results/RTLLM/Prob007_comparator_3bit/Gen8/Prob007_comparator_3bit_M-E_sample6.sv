module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    wire [2:0] diff;
    wire borrow;

    // Perform subtraction A - B
    full_subtractor fs0(A[0], B[0], 1'b0, diff[0], borrow);
    full_subtractor fs1(A[1], B[1], borrow, diff[1], borrow);
    full_subtractor fs2(A[2], B[2], borrow, diff[2], borrow);

    // Determine A_greater, A_equal, A_less based on diff and borrow
    assign A_greater = (~borrow) & (~diff[2]);
    assign A_equal = (diff[2] == 1'b0) & (diff[1] == 1'b0) & (diff[0] == 1'b0) & (~borrow);
    assign A_less = borrow;

endmodule

module full_subtractor(
    input a,
    input b,
    input borrow_in,
    output difference,
    output borrow_out
);

    assign difference = a ^ b ^ borrow_in;
    assign borrow_out = (~a & b) | (borrow_in & (~a ^ b));

endmodule