module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Perform subtraction: A - B
    wire [3:0] diff;
    wire borrow;

    // Full subtractor for 4-bit numbers
    full_subtractor fs0(A[0], B[0], 1'b0, diff[0], borrow);
    full_subtractor fs1(A[1], B[1], borrow, diff[1], borrow);
    full_subtractor fs2(A[2], B[2], borrow, diff[2], borrow);
    full_subtractor fs3(A[3], B[3], borrow, diff[3], borrow);

    // Determine A_greater, A_equal, A_less based on the result of subtraction
    assign A_less = borrow;
    assign A_equal = ~(diff[3] | diff[2] | diff[1] | diff[0] | borrow); // if result is zero and no borrow
    assign A_greater = ~(A_less | A_equal); // mutually exclusive with A_less and A_equal

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
    assign borrow_out = (~a & b) | (borrow_in & (~a | b));

endmodule