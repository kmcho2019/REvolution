module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate (g) and propagate (p) for each bit: vectors for compactness
    wire [3:0] g = (~A) & B;     // borrow generate: bit needs borrow if A[i]<B[i]
    wire [3:0] p = ~(A ^ B);     // borrow propagate: bit propagates borrow if equal

    // Balanced borrow lookahead calculation:
    // borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
    wire level1_0 = g[0];
    wire level1_1 = g[1] & p[0];
    wire level1_2 = g[2] & p[0] & p[1];
    wire level1_3 = g[3] & p[0] & p[1] & p[2];

    assign A_less = level1_0 | level1_1 | level1_2 | level1_3;

    // Equality if all bits equal: reduction AND of bitwise XNOR
    assign A_equal = &p;

    // If not less and not equal => greater
    assign A_greater = ~(A_less | A_equal);

endmodule