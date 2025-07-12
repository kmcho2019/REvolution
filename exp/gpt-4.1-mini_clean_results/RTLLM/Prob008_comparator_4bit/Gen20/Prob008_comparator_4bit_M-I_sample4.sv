module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Generate and propagate vectors: bitwise signals
    wire [3:0] g; // borrow generate: A[i] < B[i]
    wire [3:0] p; // borrow propagate: A[i] == B[i]

    assign g = (~A) & B;      // borrow generate: bits where A[i]<B[i]
    assign p = ~(A ^ B);      // borrow propagate: bits where A[i]==B[i]

    // Borrow chain (borrow in is zero)
    // borrow[0] = g[0]
    // borrow[1] = g[1] | (p[1] & g[0])
    // borrow[2] = g[2] | (p[2] & borrow[1]) = g[2] | (p[2] & (g[1] | (p[1]&g[0])))
    // borrow[3] = g[3] | (p[3] & borrow[2])
    wire b0 = g[0];
    wire b1 = g[1] | (p[1] & b0);
    wire b2 = g[2] | (p[2] & b1);
    wire borrow_out = g[3] | (p[3] & b2);

    // Equality: all bits match
    wire equal_bits = &p; // reduction AND of p bits

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule