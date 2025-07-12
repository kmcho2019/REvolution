module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire       borrow0, borrow1, borrow2, borrow3;

    // 1-bit subtractor: difference = A_bit - B_bit - borrow_in
    // borrow_out = borrow generated if A_bit < (B_bit + borrow_in)
    // Implemented combinationally
    // borrow_out = (~A & (B | borrow_in)) | (B & borrow_in)
    // difference = A ^ B ^ borrow_in

    // Bit 0 subtractor
    assign borrow0 = (~A[0] & B[0]);
    assign diff[0] = A[0] ^ B[0];

    // Bit 1 subtractor
    assign borrow1 = ((~A[1]) & (B[1] | borrow0)) | (B[1] & borrow0);
    assign diff[1] = A[1] ^ B[1] ^ borrow0;

    // Bit 2 subtractor
    assign borrow2 = ((~A[2]) & (B[2] | borrow1)) | (B[2] & borrow1);
    assign diff[2] = A[2] ^ B[2] ^ borrow1;

    // Bit 3 subtractor
    assign borrow3 = ((~A[3]) & (B[3] | borrow2)) | (B[3] & borrow2);
    assign diff[3] = A[3] ^ B[3] ^ borrow2;

    // borrow3: 1 => A < B, 0 => A >= B
    wire diff_is_zero = ~( |diff );

    assign A_less    = borrow3;
    assign A_equal   = ~borrow3 & diff_is_zero;
    assign A_greater = ~borrow3 & ~diff_is_zero;

endmodule