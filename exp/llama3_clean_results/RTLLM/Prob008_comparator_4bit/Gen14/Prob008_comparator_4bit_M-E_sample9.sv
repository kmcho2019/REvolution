module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire borrow_out;

    // Ripple-carry subtractor
    full_subtractor fs0(A[0], B[0], 0, diff[0], borrow_out);
    full_subtractor fs1(A[1], B[1], borrow_out, diff[1], borrow_out);
    full_subtractor fs2(A[2], B[2], borrow_out, diff[2], borrow_out);
    full_subtractor fs3(A[3], B[3], borrow_out, diff[3], borrow_out);

    assign A_less = borrow_out;
    assign A_equal = (~borrow_out) && (~|diff); // diff is all zeros
    assign A_greater = (~borrow_out) && (|diff); // diff is not all zeros

endmodule

module full_subtractor (
    input  a,
    input  b,
    input  borrow_in,
    output diff,
    output borrow_out
);

    assign diff = a - b - borrow_in;
    assign borrow_out = (~a & b) | (~a & borrow_in) | (b & borrow_in);

endmodule