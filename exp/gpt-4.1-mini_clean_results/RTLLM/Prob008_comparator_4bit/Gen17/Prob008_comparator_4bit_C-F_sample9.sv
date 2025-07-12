module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality: eq[i] = ~(A[i] ^ B[i])
    wire [3:0] eq = ~(A ^ B);

    // Equality: all bits equal if all eq bits are 1
    wire all_equal = &eq;

    // Borrow generate signals: g[i] = (~A[i]) & B[i]
    wire [3:0] g = (~A) & B;

    // Borrow propagate signals: p[i] = eq[i]
    wire [3:0] p = eq;

    // Factored borrow_out calculation:
    // borrow_out = g3 | (p3 & (g2 | (p2 & (g1 | (p1 & g0)))))
    wire borrow_out = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & g[0])))));

    // Outputs (mutually exclusive)
    assign A_less    = borrow_out;
    assign A_equal   = all_equal;
    assign A_greater = ~(borrow_out | all_equal);

endmodule