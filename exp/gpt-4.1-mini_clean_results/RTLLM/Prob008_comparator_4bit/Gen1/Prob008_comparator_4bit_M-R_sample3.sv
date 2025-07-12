module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [3:0] borrow;

    // Borrow[0] is borrow from bit 0 subtract; we use an internal borrow chain borrow[-1]=0
    wire borrow_in = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : SUB_BITS
            if (i == 0) begin
                // Bit 0 subtract: diff = A ^ B, borrow = (~A & B)
                assign diff[i] = A[i] ^ B[i];
                assign borrow[i] = (~A[i]) & B[i];
            end else begin
                // Subsequent bits: diff = A ^ B ^ borrow_in, borrow_out = (~A & B) | ((~A | B) & borrow_in)
                assign diff[i] = A[i] ^ B[i] ^ borrow[i-1];
                assign borrow[i] = ((~A[i]) & B[i]) | (((~A[i]) | B[i]) & borrow[i-1]);
            end
        end
    endgenerate

    wire result_zero = ~( |diff );

    assign A_less    = borrow[3];
    assign A_equal   = ~borrow[3] & result_zero;
    assign A_greater = ~borrow[3] & ~result_zero;

endmodule