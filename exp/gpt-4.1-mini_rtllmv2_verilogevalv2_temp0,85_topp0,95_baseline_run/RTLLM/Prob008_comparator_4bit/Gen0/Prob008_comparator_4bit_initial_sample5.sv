module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [3:0] borrow;

    // Bitwise subtraction with borrow propagation
    // diff[i] = A[i] ^ B[i] ^ borrow[i-1]
    // borrow[i] = (~A[i] & (B[i] | borrow[i-1])) | (B[i] & borrow[i-1])
    // borrow[-1] = 0 for LSB subtraction

    assign borrow[0] = (~A[0] & B[0]);
    assign diff[0]   = A[0] ^ B[0];

    assign borrow[1] = (~A[1] & (B[1] | borrow[0])) | (B[1] & borrow[0]);
    assign diff[1]   = A[1] ^ B[1] ^ borrow[0];

    assign borrow[2] = (~A[2] & (B[2] | borrow[1])) | (B[2] & borrow[1]);
    assign diff[2]   = A[2] ^ B[2] ^ borrow[1];

    assign borrow[3] = (~A[3] & (B[3] | borrow[2])) | (B[3] & borrow[2]);
    assign diff[3]   = A[3] ^ B[3] ^ borrow[2];

    wire borrow_out = borrow[3];

    wire diff_zero = ~(diff[0] | diff[1] | diff[2] | diff[3]);

    assign A_less    = borrow_out;
    assign A_equal   = (~borrow_out) & diff_zero;
    assign A_greater = (~borrow_out) & (~diff_zero);

endmodule