module TopModule(
    input  [3:0] x, // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output      f
);
    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // From Karnaugh map, with convenient don't-cares chosen to simplify:
    // Minterms for f=1 (rows x4x3, columns x2x1):
    // Row 11 (x4=1,x3=1): columns 00 and 01 => (x4 & x3 & ~x2 & ~x1) + (x4 & x3 & ~x2 & x1)
    // Row 10 (x4=1,x3=0): columns 00 and 01 => (x4 & ~x3 & ~x2 & ~x1) + (x4 & ~x3 & ~x2 & x1)
    // Row 01 (x4=0,x3=1): column 11 => (~x4 & x3 & x2 & x1)
    // Also from Row 10 (x4=1,x3=0): column 11 is 0, so ignored

    // Grouped terms:
    // Group1: x4 & x3 & ~x2 & ( ~x1 + x1 ) = x4 & x3 & ~x2
    // Group2: x4 & ~x3 & ~x2 & ( ~x1 + x1 ) = x4 & ~x3 & ~x2
    // Group3: ~x4 & x3 & x2 & x1

    assign f = (x4 & x3 & ~x2) | (x4 & ~x3 & ~x2) | (~x4 & x3 & x2 & x1);

endmodule