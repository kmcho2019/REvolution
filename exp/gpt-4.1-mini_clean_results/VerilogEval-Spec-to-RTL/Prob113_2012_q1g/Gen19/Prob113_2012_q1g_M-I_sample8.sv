module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    wire nx3 = ~x3;

    // Term A: (~x1 | (x2 & ~x0))
    // Complemented x1 and x0 are used only once, so inline them.
    wire termA = (~x1) | (x2 & ~x0);

    // Final function:
    // f = (~x3 & termA) | (x3 & x2 & (~x0 | x1))
    assign f = (nx3 & termA) | (x3 & x2 & (~x0 | x1));

endmodule