module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);
    wire [3:0] diff;     // Difference bits A - B
    wire [4:0] borrow;   // Borrow signals, borrow[0] = 0 (initial)

    assign borrow[0] = 1'b0;

    // Bitwise subtraction with borrow propagation: diff = A - B
    genvar i;
    generate
        for (i = 0; i < 4; i = i+1) begin : subtract_bits
            // full subtractor logic:
            // diff[i] = A[i] ^ B[i] ^ borrow[i]
            // borrow[i+1] = (~A[i] & (B[i] | borrow[i])) | (B[i] & borrow[i])
            assign diff[i] = A[i] ^ B[i] ^ borrow[i];
            assign borrow[i+1] = (~A[i] & (B[i] | borrow[i])) | (B[i] & borrow[i]);
        end
    endgenerate

    wire zero_diff = (diff == 4'b0000);

    assign A_less    = borrow[4];           // Borrow out means A < B
    assign A_equal   = (~borrow[4]) & zero_diff;
    assign A_greater = (~borrow[4]) & (~zero_diff);

endmodule