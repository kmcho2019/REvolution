module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] borrow;

    // Bit 0 borrow
    assign borrow[0] = (~A[0] & B[0]);

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : BORROW_GEN
            // borrow_out = (~A & B) | ((~(A ^ B)) & borrow_in)
            assign borrow[i] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i-1]);
        end
    endgenerate

    // Equality check: all bits equal if bitwise XNOR across all bits is 1
    wire eq_bits;
    assign eq_bits = &(~(A ^ B)); // bitwise XNOR reduction

    // Outputs: mutually exclusive
    assign A_less    = borrow[3];
    assign A_equal   = (~borrow[3]) & eq_bits;
    assign A_greater = (~borrow[3]) & (~eq_bits);

endmodule