module TopModule(
    input  [3:0] x, // x[0]=x1, x[1]=x2, x[2]=x3, x[3]=x4
    output       f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From Karnaugh map and corrected mapping:
    // f = (x4 & ~x3 & ~x1) | (x4 & x3 & ~x1) | (~x4 & x3 & x2 & x1);

    assign f = (x4 & ~x3 & ~x1) | (x4 & x3 & ~x1) | (~x4 & x3 & x2 & x1);

endmodule