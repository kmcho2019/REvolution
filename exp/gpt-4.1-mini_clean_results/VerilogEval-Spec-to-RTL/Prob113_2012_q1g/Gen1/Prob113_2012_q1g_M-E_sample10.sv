module TopModule(
    input  [3:0] x,
    output       f
);
    wire g1, g2, g3;

    // Group 1: ~x[3] & ~x[2] & ~x[0]
    assign g1 = ~x[3] & ~x[2] & ~x[0];

    // Group 2: x[3] & ~x[2] & (~x[1] | ~x[0])
    assign g2 = x[3] & ~x[2] & (~x[1] | ~x[0]);

    // Group 3: x[3] & x[2] & (~x[1] | (x[1] & x[0])) 
    // which simplifies to x[3] & x[2] & (~x[1] | (x[1] & x[0]))
    assign g3 = x[3] & x[2] & (~x[1] | (x[1] & x[0]));

    assign f = g1 | g2 | g3;

endmodule