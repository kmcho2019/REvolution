module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Shared complements for reduced inverter count
    wire nx3 = ~x3;
    wire nx1 = ~x1;
    wire nx0 = ~x0;

    // Term 1: (~x3 & ~x1)
    wire term1 = nx3 & nx1;

    // Term 2: (~x3 & x2 & x1 & ~x0)
    wire term2 = nx3 & x2 & x1 & nx0;

    // Term 3: (x3 & x2 & (~x0 | (x1 & x0)))
    wire term3 = x3 & x2 & (nx0 | (x1 & x0));

    assign f = term1 | term2 | term3;

endmodule