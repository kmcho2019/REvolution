module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality signals (bitwise XNOR)
    wire eq0 = (A[0] ~^ B[0]);
    wire eq1 = (A[1] ~^ B[1]);
    wire eq2 = (A[2] ~^ B[2]);
    wire eq3 = (A[3] ~^ B[3]);

    // Borrow generate signals: borrow generated if A[i] < B[i]
    wire g0 = (~A[0]) & B[0];
    wire g1 = (~A[1]) & B[1];
    wire g2 = (~A[2]) & B[2];
    wire g3 = (~A[3]) & B[3];

    // Borrow propagate signals: borrow propagates if bits are equal
    wire p0 = eq0;
    wire p1 = eq1;
    wire p2 = eq2;
    wire p3 = eq3;

    // Hierarchical borrow_out calculation with factored terms:
    // borrow_out = g3 | (p3 & (g2 | (p2 & (g1 | (p1 & g0)))))
    wire borrow_out = g3 | (p3 & (g2 | (p2 & (g1 | (p1 & g0)))));

    // Balanced AND tree for equality checking
    wire eq_01 = eq0 & eq1;
    wire eq_23 = eq2 & eq3;
    wire equal_bits = eq_01 & eq_23;

    // Mutually exclusive outputs
    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule