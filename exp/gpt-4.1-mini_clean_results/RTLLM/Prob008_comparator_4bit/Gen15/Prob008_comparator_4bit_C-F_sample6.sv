module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality signals (XNOR)
    wire [3:0] eq_bit;
    assign eq_bit = ~(A ^ B);

    // Borrow generate and propagate signals
    wire [3:0] g = (~A) & B;      // borrow generated if A[i] < B[i]
    wire [3:0] p = eq_bit;        // borrow propagates if bits are equal

    // Explicit borrow chain signals
    wire borrow_1 = g[0];
    wire borrow_2 = g[1] | (p[1] & borrow_1);
    wire borrow_3 = g[2] | (p[2] & borrow_2);
    wire borrow_4 = g[3] | (p[3] & borrow_3);

    // Balanced AND tree for equality detection
    wire eq_01 = eq_bit[0] & eq_bit[1];
    wire eq_23 = eq_bit[2] & eq_bit[3];
    wire equal_bits = eq_01 & eq_23;

    // Outputs (mutually exclusive)
    assign A_less    = borrow_4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(A_less | A_equal);

endmodule