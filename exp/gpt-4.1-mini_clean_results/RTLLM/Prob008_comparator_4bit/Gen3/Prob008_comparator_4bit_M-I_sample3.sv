module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate and propagate signals for each bit
    wire g0, g1, g2, g3;  // borrow generate: when current bit causes borrow regardless of input borrow
    wire p0, p1, p2, p3;  // borrow propagate: when borrow-in passes through this bit

    // Borrow generate: borrow needed at bit i if A[i] < B[i]
    assign g0 = (~A[0]) & B[0];
    assign g1 = (~A[1]) & B[1];
    assign g2 = (~A[2]) & B[2];
    assign g3 = (~A[3]) & B[3];

    // Borrow propagate: borrow-in propagates if A[i] == B[i]
    assign p0 = ~(A[0] ^ B[0]);
    assign p1 = ~(A[1] ^ B[1]);
    assign p2 = ~(A[2] ^ B[2]);
    assign p3 = ~(A[3] ^ B[3]);

    // Borrow lookahead chain:
    // borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & borrow_in)
    // borrow_in = 0 for subtraction A - B
    wire borrow_out;
    assign borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);

    // Equality: all bits equal if all A[i] == B[i]
    wire equal_bits;
    assign equal_bits = p0 & p1 & p2 & p3;

    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule