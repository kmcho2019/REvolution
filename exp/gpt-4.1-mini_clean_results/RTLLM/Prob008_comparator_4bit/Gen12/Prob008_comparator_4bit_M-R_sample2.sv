module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [4:0] borrow; // borrow chain: borrow[0] is initial borrow_in (0)

    assign borrow[0] = 1'b0; // no initial borrow in subtraction

    // Bit 0
    assign diff[0] = A[0] ^ B[0] ^ borrow[0];
    assign borrow[1] = (~A[0] & (B[0] | borrow[0])) | (B[0] & borrow[0]);

    // Bit 1
    assign diff[1] = A[1] ^ B[1] ^ borrow[1];
    assign borrow[2] = (~A[1] & (B[1] | borrow[1])) | (B[1] & borrow[1]);

    // Bit 2
    assign diff[2] = A[2] ^ B[2] ^ borrow[2];
    assign borrow[3] = (~A[2] & (B[2] | borrow[2])) | (B[2] & borrow[2]);

    // Bit 3
    assign diff[3] = A[3] ^ B[3] ^ borrow[3];
    assign borrow[4] = (~A[3] & (B[3] | borrow[3])) | (B[3] & borrow[3]);

    // borrow[4] is final borrow out; if 1 => A < B
    assign A_less = borrow[4];

    // Check if difference == 0 (all bits zero)
    assign A_equal = (diff == 4'b0000);

    // A_greater if not less and not equal
    assign A_greater = ~A_less & ~A_equal;

endmodule