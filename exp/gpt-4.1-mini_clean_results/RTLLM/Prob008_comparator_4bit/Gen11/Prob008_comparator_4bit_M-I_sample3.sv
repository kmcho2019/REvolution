module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate: g[i] = (~A[i]) & B[i]
    wire [3:0] g = (~A) & B;
    // Borrow propagate: p[i] = ~(A[i] ^ B[i]) -> A[i] == B[i]
    wire [3:0] p = ~(A ^ B);

    // Compute borrow_out with borrow lookahead logic:
    // borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
    wire borrow_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

    // Equality: all bits equal if all bits of p are 1 (all bits equal => p[i] = 1)
    wire equal_bits = &p;

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule