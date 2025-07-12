module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate and propagate vectors
    wire [3:0] g = (~A) & B;      // borrow generated if A[i]<B[i]
    wire [3:0] p = ~(A ^ B);      // borrow propagated if A[i]==B[i]

    // Borrow lookahead logic (balanced)
    // borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
    wire p3g2     = p[3] & g[2];
    wire p3p2g1   = p[3] & p[2] & g[1];
    wire p3p2p1g0 = p[3] & p[2] & p[1] & g[0];
    wire borrow_out = g[3] | p3g2 | p3p2g1 | p3p2p1g0;

    // Bitwise equality using XNOR (A==B)
    wire [3:0] bit_equal = ~(A ^ B);

    // Balanced AND tree for equality detection
    wire eq_01 = bit_equal[0] & bit_equal[1];
    wire eq_23 = bit_equal[2] & bit_equal[3];
    wire equal_bits = eq_01 & eq_23;

    // Mutually exclusive outputs
    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule