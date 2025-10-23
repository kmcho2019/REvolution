module TopModule(
    input  [3:0] x,
    output       f
);

    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    // Compute terms for XNOR equivalence without XOR gates:
    // x1_xnor_x3 = (x1 & x3) | (~(x1 | x3))
    wire x1_and_x3 = x1 & x3;
    wire x1_or_x3  = x1 | x3;
    wire not_x1_or_x3 = ~x1_or_x3;

    wire x1_xnor_x3 = x1_and_x3 | not_x1_or_x3;

    // Final expression:
    // f = (~x2 & ~x3 & ~x1) | (x2 & (~x0 | x1_xnor_x3))
    assign f = (~x2 & ~x3 & ~x1) | (x2 & (~x0 | x1_xnor_x3));

endmodule