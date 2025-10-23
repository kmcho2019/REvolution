module TopModule(
    input  [3:0] x,
    output       f
);

    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    // Compute (x1 & x3) and (~x1 & ~x3) terms for XNOR equivalence
    wire x1_and_x3       = x1 & x3;
    wire not_x1          = ~x1;
    wire not_x3          = ~x3;
    wire not_x1_and_not_x3 = not_x1 & not_x3;

    wire x1_xnor_x3 = x1_and_x3 | not_x1_and_not_x3;

    // Implement fused and optimized expression:
    // f = (~x2 & ~x3 & ~x1) | (x2 & (~x0 | x1_xnor_x3))
    assign f = (~x2 & ~x3 & ~x1) | (x2 & (~x0 | x1_xnor_x3));

endmodule