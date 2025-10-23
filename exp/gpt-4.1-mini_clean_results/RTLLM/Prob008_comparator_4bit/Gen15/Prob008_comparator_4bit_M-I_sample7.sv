module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Per-bit equality (XNOR) signals
    wire eq0 = ~(A[0] ^ B[0]);
    wire eq1 = ~(A[1] ^ B[1]);
    wire eq2 = ~(A[2] ^ B[2]);
    wire eq3 = ~(A[3] ^ B[3]);

    // Equality: direct reduction AND of eq bits
    wire equal_bits = eq0 & eq1 & eq2 & eq3;

    // Borrow generation per bit: borrow generated if A[i]<B[i]
    wire g0 = (~A[0]) & B[0];
    wire g1 = (~A[1]) & B[1];
    wire g2 = (~A[2]) & B[2];
    wire g3 = (~A[3]) & B[3];

    // Borrow propagation (propagate if bits equal)
    wire p0 = eq0;
    wire p1 = eq1;
    wire p2 = eq2;
    wire p3 = eq3;

    // Ripple borrow chain (borrow signals between bits)
    wire borrow1 = g0;
    wire borrow2 = g1 | (p1 & borrow1);
    wire borrow3 = g2 | (p2 & borrow2);
    wire borrow4 = g3 | (p3 & borrow3);

    // Outputs
    assign A_less    = borrow4;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow4 | equal_bits);

endmodule