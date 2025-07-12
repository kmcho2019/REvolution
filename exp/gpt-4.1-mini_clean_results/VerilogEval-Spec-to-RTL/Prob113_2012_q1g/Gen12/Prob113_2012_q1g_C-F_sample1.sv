module TopModule(
    input  [3:0] x,
    output       f
);

    // Extract individual bits for clarity
    wire x0 = x[0];
    wire x1 = x[1];
    wire x2 = x[2];
    wire x3 = x[3];

    // Compute XNOR of x1 and x3
    wire x1_xnor_x3 = ~(x1 ^ x3);

    // Partial terms of the expression:
    wire term_a = ~x2 & ~x3 & ~x1;
    wire term_b = x2 & (~x0 | x1_xnor_x3);

    // Combine terms for final output
    assign f = term_a | term_b;

endmodule