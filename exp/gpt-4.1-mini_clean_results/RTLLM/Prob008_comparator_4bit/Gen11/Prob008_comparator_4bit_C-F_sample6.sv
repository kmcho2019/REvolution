module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality signals (XNOR)
    wire eq_bit [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : eq_gen
            assign eq_bit[i] = ~(A[i] ^ B[i]);
        end
    endgenerate

    // Borrow generate vector: borrow generated at bit i if A[i]<B[i]
    wire [3:0] g = (~A) & B;
    // Borrow propagate vector: borrow propagates if bits equal
    wire [3:0] p = {eq_bit[3], eq_bit[2], eq_bit[1], eq_bit[0]};

    // Explicit borrow chain (borrow signals at each bit)
    wire borrow_1 = g[0];
    wire borrow_2 = g[1] | (p[1] & borrow_1);
    wire borrow_3 = g[2] | (p[2] & borrow_2);
    wire borrow_4 = g[3] | (p[3] & borrow_3);

    // Balanced AND tree for equality detection to reduce glitch and depth
    wire eq_01 = eq_bit[0] & eq_bit[1];
    wire eq_23 = eq_bit[2] & eq_bit[3];
    wire equal_bits = eq_01 & eq_23;

    // Outputs: mutually exclusive encoding
    assign A_less    = borrow_4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_4 | equal_bits);

endmodule