module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Borrow generate and propagate signals
    wire [3:0] g = (~A) & B;
    wire [3:0] p = ~(A ^ B);

    // Borrow lookahead: borrow_out = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
    wire g2p3      = g[2] & p[3];
    wire g1p2p3    = g[1] & p[2] & p[3];
    wire g0p1p2p3  = g[0] & p[1] & p[2] & p[3];
    wire borrow_out = g[3] | g2p3 | g1p2p3 | g0p1p2p3;

    // Equality check using bitwise XNOR and AND reduction
    wire equal_bits = &(~(A ^ B));

    // Outputs: mutually exclusive
    assign A_less    = borrow_out;
    assign A_equal   = equal_bits;
    assign A_greater = ~(borrow_out | equal_bits);

endmodule