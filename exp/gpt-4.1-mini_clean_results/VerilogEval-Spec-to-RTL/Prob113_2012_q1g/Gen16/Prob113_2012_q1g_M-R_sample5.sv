module TopModule(
    input  [3:0] x,
    output       f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Direct expression from the Karnaugh map:
    // f = (~x3 & ~x1) | (x2 & x1 & ~x0 & ~x3) | (x3 & x2 & (~x0 | (x1 & x0)))
    // Implemented as a single assign statement without intermediate wires
    assign f = (~x3 & ~x1)
             | (x2 & x1 & ~x0 & ~x3)
             | (x3 & x2 & (~x0 | (x1 & x0)));

endmodule