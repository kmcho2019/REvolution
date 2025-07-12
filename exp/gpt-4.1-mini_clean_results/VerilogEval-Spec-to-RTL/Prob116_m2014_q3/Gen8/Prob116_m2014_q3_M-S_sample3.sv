module TopModule(
    input  [3:0] x,
    output      f
);

    wire x3 = x[3];
    wire x2 = x[2];
    wire x1 = x[1];
    wire x0 = x[0];

    assign f = (x3 & x2 & ~x1)         // Row 11, col 00 or 01 (x1=0)
             | (~x3 & x2 & x1 & x0)   // Row 01, col 11
             | (x3 & ~x2 & ~x1);      // Row 10, col 00 or 01 (x1=0)

endmodule