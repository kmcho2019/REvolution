module TopModule (
    input  [3:0] x,
    output      f
);
    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    // Final expression:
    // f = (x3 & x2 & ~x1) | (x3 & ~x2 & ~x1) | (~x3 & x2 & x1 & x0)
    assign f = (x3 & x2 & ~x1) | (x3 & ~x2 & ~x1) | (~x3 & x2 & x1 & x0);

endmodule