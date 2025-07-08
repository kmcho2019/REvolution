module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // Bit 0 subtraction: A[0] - B[0] - borrow_in (borrow_in=0)
    assign diff[0] = A[0] ^ B[0];
    assign borrow0 = (~A[0] & B[0]);

    // Bit 1 subtraction: A[1] - B[1] - borrow0
    assign diff[1] = A[1] ^ B[1] ^ borrow0;
    assign borrow1 = (~A[1] & (B[1] | borrow0)) | (B[1] & borrow0);

    // Bit 2 subtraction: A[2] - B[2] - borrow1
    assign diff[2] = A[2] ^ B[2] ^ borrow1;
    assign borrow2 = (~A[2] & (B[2] | borrow1)) | (B[2] & borrow1);

    // Bit 3 subtraction: A[3] - B[3] - borrow2
    assign diff[3] = A[3] ^ B[3] ^ borrow2;
    assign borrow3 = (~A[3] & (B[3] | borrow2)) | (B[3] & borrow2);

    wire all_diff_zero = ~(diff[0] | diff[1] | diff[2] | diff[3]);

    assign A_less    = borrow3;
    assign A_equal   = (~borrow3) & all_diff_zero;
    assign A_greater = (~borrow3) & ~all_diff_zero;

endmodule