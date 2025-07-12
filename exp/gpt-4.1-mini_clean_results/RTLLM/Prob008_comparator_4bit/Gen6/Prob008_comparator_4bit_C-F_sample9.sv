module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] borrow;

    // Borrow generation for bit 0 (no borrow-in, borrow_in = 0)
    assign borrow[0] = (~A[0] & B[0]);

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : borrow_chain
            // borrow_out = (~A & B) | ((~(A ^ B)) & borrow_in)
            assign borrow[i] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i-1]);
        end
    endgenerate

    // Equality check using bitwise XNOR reduction (all bits equal)
    wire eq_bits = &(~(A ^ B));

    // Mutually exclusive output encoding based on borrow and equality signals
    assign A_less    = borrow[3];
    assign A_equal   = (~borrow[3]) & eq_bits;
    assign A_greater = (~borrow[3]) & (~eq_bits);

endmodule