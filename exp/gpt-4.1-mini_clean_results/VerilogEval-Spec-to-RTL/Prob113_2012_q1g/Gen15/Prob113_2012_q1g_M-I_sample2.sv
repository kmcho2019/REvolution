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

    // First group: (~x3 & ( ~x1 | (x2 & x1 & ~x0) ))
    // Compute inner OR: ~x1 | (x2 & x1 & ~x0)
    wire and_sub = x2 & x1 & nx0;
    wire or_group = nx1 | and_sub;
    wire term_low = nx3 & or_group;

    // Second group: (x3 & x2 & (~x0 | x1))
    wire or_high = nx0 | x1;
    wire term_high = x3 & x2 & or_high;

    assign f = term_low | term_high;

endmodule