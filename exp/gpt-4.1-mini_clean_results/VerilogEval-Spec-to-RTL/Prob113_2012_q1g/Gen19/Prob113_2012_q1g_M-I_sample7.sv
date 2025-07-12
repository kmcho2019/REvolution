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

    // Term1: (~x3 & ~x1)
    wire term1 = nx3 & nx1;

    // Term2: (~x3 & x2 & x1 & ~x0) - directly as 4-input AND without intermediates
    wire term2 = nx3 & x2 & x1 & nx0;

    // Term3: (x3 & x2 & (~x0 | x1))
    wire or_inner = nx0 | x1;
    wire term3 = x3 & x2 & or_inner;

    assign f = term1 | term2 | term3;

endmodule