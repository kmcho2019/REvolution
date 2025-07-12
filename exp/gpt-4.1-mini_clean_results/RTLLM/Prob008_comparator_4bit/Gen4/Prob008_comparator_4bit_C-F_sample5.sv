module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate and propagate signals for borrow lookahead
    wire g0 = (~A[0]) & B[0];
    wire g1 = (~A[1]) & B[1];
    wire g2 = (~A[2]) & B[2];
    wire g3 = (~A[3]) & B[3];

    wire p0 = ~(A[0] ^ B[0]);
    wire p1 = ~(A[1] ^ B[1]);
    wire p2 = ~(A[2] ^ B[2]);
    wire p3 = ~(A[3] ^ B[3]);

    // Borrow out calculation using borrow lookahead logic
    wire borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);

    // Precompute XOR for difference calculation (A - B)
    wire [3:0] AxorB = A ^ B;

    // Ripple borrow chain for difference bits
    wire b0 = g0; // borrow from bit 0, same as Example 2
    wire d0 = AxorB[0];
    wire b1 = ((~A[1]) & B[1]) | ((~AxorB[1]) & b0);
    wire d1 = AxorB[1] ^ b0;
    wire b2 = ((~A[2]) & B[2]) | ((~AxorB[2]) & b1);
    wire d2 = AxorB[2] ^ b1;
    wire b3 = ((~A[3]) & B[3]) | ((~AxorB[3]) & b2);
    wire d3 = AxorB[3] ^ b2;

    wire [3:0] diff = {d3, d2, d1, d0};

    // Equality: difference zero means A==B
    wire diff_zero = ~|diff;

    // Outputs: mutually exclusive
    assign A_less    = borrow_out;
    assign A_equal   = diff_zero & ~borrow_out;
    assign A_greater = ~borrow_out & ~diff_zero;

endmodule