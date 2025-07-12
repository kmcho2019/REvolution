module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Simplify (~x1 | (x2 & x1 & ~x0)) as (~x1) | (x1 & x2 & ~x0)
    wire and_mid = x2 & nx0;       // (x2 & ~x0)
    wire and_mux = x1 & and_mid;  // x1 & (x2 & ~x0)
    wire or_low = nx1 | and_mux;  // (~x1) | (x1 & x2 & ~x0)
    wire term_low = nx3 & or_low;

    // High group: (x3 & x2 & (x1 | ~x0))
    wire or_high = x1 | nx0;
    wire term_high = x3 & x2 & or_high;

    assign f = term_low | term_high;

endmodule