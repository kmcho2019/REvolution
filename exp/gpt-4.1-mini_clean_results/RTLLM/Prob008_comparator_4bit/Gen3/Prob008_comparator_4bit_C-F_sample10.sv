module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] borrow;

    // Bit 0 borrow generation using standard full subtractor logic
    assign borrow[0] = (~A[0] & B[0]);

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : BORROW_CHAIN
            assign borrow[i] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i-1]);
        end
    endgenerate

    // Equality check by bitwise XNOR and reduction AND
    wire eq_bits;
    assign eq_bits = &(~(A ^ B));

    // Outputs are mutually exclusive:
    // borrow[3] = 1 means A < B
    // borrow[3] = 0 & eq_bits = 1 means A == B
    // borrow[3] = 0 & eq_bits = 0 means A > B
    assign A_less    = borrow[3];
    assign A_equal   = (~borrow[3]) & eq_bits;
    assign A_greater = (~borrow[3]) & (~eq_bits);

endmodule