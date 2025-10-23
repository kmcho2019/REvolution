module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [4:0] borrow;

    assign borrow[0] = 1'b0;

    // 1-bit subtractor module instantiations for each bit
    subtractor_1bit sub0 (
        .a(A[0]),
        .b(B[0]),
        .borrow_in(borrow[0]),
        .diff(diff[0]),
        .borrow_out(borrow[1])
    );

    subtractor_1bit sub1 (
        .a(A[1]),
        .b(B[1]),
        .borrow_in(borrow[1]),
        .diff(diff[1]),
        .borrow_out(borrow[2])
    );

    subtractor_1bit sub2 (
        .a(A[2]),
        .b(B[2]),
        .borrow_in(borrow[2]),
        .diff(diff[2]),
        .borrow_out(borrow[3])
    );

    subtractor_1bit sub3 (
        .a(A[3]),
        .b(B[3]),
        .borrow_in(borrow[3]),
        .diff(diff[3]),
        .borrow_out(borrow[4])
    );

    wire borrow_out = borrow[4];
    wire diff_zero = (diff == 4'b0000);

    assign A_less    = borrow_out;
    assign A_equal   = (~borrow_out) & diff_zero;
    assign A_greater = (~borrow_out) & (~diff_zero);

endmodule


// 1-bit subtractor module with borrow in and borrow out
module subtractor_1bit (
    input  a,
    input  b,
    input  borrow_in,
    output diff,
    output borrow_out
);
    // Difference bit
    assign diff = a ^ b ^ borrow_in;

    // Borrow out calculation:
    // borrow_out = (~a & b) | ((~a | b) & borrow_in)
    assign borrow_out = (~a & b) | ((~a | b) & borrow_in);

endmodule