module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality signals (XNOR)
    wire [3:0] eq_bit;
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : eq_gen
            assign eq_bit[i] = ~(A[i] ^ B[i]);
        end
    endgenerate

    // Ripple borrow chain for A < B detection
    wire [4:0] borrow;
    assign borrow[0] = 1'b0;
    generate
        for (i = 0; i < 4; i = i + 1) begin : borrow_chain
            // borrow_out = (~A[i] & B[i]) | (eq_bit[i] & borrow_in)
            assign borrow[i+1] = (~A[i] & B[i]) | (eq_bit[i] & borrow[i]);
        end
    endgenerate

    // Balanced AND tree for equality detection to reduce glitches and logic depth
    wire eq_01 = eq_bit[0] & eq_bit[1];
    wire eq_23 = eq_bit[2] & eq_bit[3];
    wire equal_bits = eq_01 & eq_23;

    // Outputs: mutually exclusive encoding
    assign A_less    = borrow[4];
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow[4] | equal_bits);

endmodule