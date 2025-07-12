module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate (g) and propagate (p)
    wire [3:0] g = (~A) & B;      // borrow generated at each bit if A[i]<B[i]
    wire [3:0] p = ~(A ^ B);      // borrow propagated if bits are equal

    // Borrow lookahead calculation (balanced OR of AND terms)
    wire g2p3    = g[2] & p[3];
    wire g1p2p3  = g[1] & p[2] & p[3];
    wire g0p1p2p3 = g[0] & p[1] & p[2] & p[3];

    wire borrow_out = g[3] | g2p3 | g1p2p3 | g0p1p2p3;

    // Bitwise equality using XNOR (A==B)
    wire [3:0] bit_equal = ~(A ^ B);

    // Balanced AND tree for equality check
    wire eq_01 = bit_equal[0] & bit_equal[1];
    wire eq_23 = bit_equal[2] & bit_equal[3];
    wire equal_bits = eq_01 & eq_23;

    // Outputs: mutually exclusive signals
    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule