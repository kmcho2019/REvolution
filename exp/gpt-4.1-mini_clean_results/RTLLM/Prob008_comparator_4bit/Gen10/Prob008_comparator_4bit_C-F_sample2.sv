module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality signals using XNOR for clarity and synthesis friendliness
    wire [3:0] eq_bit;
    assign eq_bit = ~(A ^ B);  // eq_bit[i] = 1 if A[i] == B[i]

    // Borrow generate (g) and propagate (p) signals for subtractor borrow logic:
    // g[i] = borrow generated at bit i if A[i] < B[i]
    // p[i] = borrow propagated at bit i if A[i] == B[i]
    wire [3:0] g = (~A) & B;
    wire [3:0] p = eq_bit;

    // Balanced borrow lookahead computation:
    // borrow_out = g[3] | (p[3]&g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0])
    wire g2p3     = g[2] & p[3];
    wire g1p2p3   = g[1] & p[2] & p[3];
    wire g0p1p2p3 = g[0] & p[1] & p[2] & p[3];
    wire borrow_out = g[3] | g2p3 | g1p2p3 | g0p1p2p3;

    // Balanced equality detection as AND tree over eq_bit
    wire eq_01 = eq_bit[0] & eq_bit[1];
    wire eq_23 = eq_bit[2] & eq_bit[3];
    wire equal_bits = eq_01 & eq_23;

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~borrow_out & ~equal_bits;

endmodule