module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire [3:0] diff;
    wire [3:0] borrow;
    wire        eq_bits;

    // Bit 0 subtraction and borrow
    assign diff[0] = A[0] ^ B[0];
    assign borrow[0] = (~A[0] & B[0]);

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : SUB_BITS
            assign diff[i] = A[i] ^ B[i] ^ borrow[i-1];
            // borrow_out = (~A & B) | ((~A ^ B) & borrow_in)
            assign borrow[i] = (~A[i] & B[i]) | ((~(A[i] ^ B[i])) & borrow[i-1]);
        end
    endgenerate

    // Equality check: bitwise XNOR followed by AND reduction for all bits
    assign eq_bits = &(~(A ^ B));

    // Outputs assignment: mutually exclusive signals
    // borrow[3] = 1 -> A < B
    // borrow[3] = 0 and eq_bits = 1 -> A == B
    // borrow[3] = 0 and eq_bits = 0 -> A > B
    assign A_less    = borrow[3];
    assign A_equal   = ~borrow[3] & eq_bits;
    assign A_greater = ~borrow[3] & ~eq_bits;

endmodule