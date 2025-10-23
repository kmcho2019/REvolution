module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Term A: ~x3 & ~x1
    wire termA = ~x3 & ~x1;

    // Term B1: ~x3 & x1 & ~x0
    wire termB1 = ~x3 & x1 & ~x0;

    // Term B2_part: x1 | ~x0
    wire termB2_part = x1 | ~x0;

    // Term B2: x3 & termB2_part
    wire termB2 = x3 & termB2_part;

    // Term B: x2 & (termB1 | termB2)
    wire termB = x2 & (termB1 | termB2);

    assign f = termA | termB;

endmodule