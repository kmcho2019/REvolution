module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [4:0] borrow;  // borrow chain, borrow[0] = 0 at start

    assign borrow[0] = 0;

    // Bit-level subtraction with borrow generation:
    // diff[i] = A[i] xor B[i] xor borrow[i]
    // borrow[i+1] = (~A[i] & B[i]) | ((~A[i] | B[i]) & borrow[i])
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : sub_bits
            assign diff[i] = A[i] ^ B[i] ^ borrow[i];
            assign borrow[i+1] = (~A[i] & B[i]) | ((~A[i] | B[i]) & borrow[i]);
        end
    endgenerate

    wire result_zero = (diff == 4'b0000);
    wire borrow_out = borrow[4];

    assign A_less    = borrow_out;
    assign A_equal   = (~borrow_out) & result_zero;
    assign A_greater = (~borrow_out) & (~result_zero);

endmodule