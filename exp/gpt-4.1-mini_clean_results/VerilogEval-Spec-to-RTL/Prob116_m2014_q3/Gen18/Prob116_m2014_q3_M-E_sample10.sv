module TopModule (
    input  [3:0] x,  // x[3]=x4, x[2]=x3, x[1]=x2, x[0]=x1
    output       f
);

    wire x1 = x[0];
    wire x2 = x[1];
    wire x3 = x[2];
    wire x4 = x[3];

    // Analyzing the K-map directly (x4 x3 on rows, x2 x1 on columns):
    //
    // x4 x3 \ x2 x1 | 00  | 01  | 11  | 10
    // 00 (0,0)     |  d  |  0  |  d  |  d
    // 01 (0,1)     |  0  |  d  |  1  |  0
    // 11 (1,1)     |  1  |  1  |  d  |  d
    // 10 (1,0)     |  1  |  1  |  0  |  d

    // Let's write the minterms (where f=1):
    // Row 01 col 11:  x4=0 x3=1 x2=1 x1=1
    // Row 11 col 00:  x4=1 x3=1 x2=0 x1=0
    // Row 11 col 01:  x4=1 x3=1 x2=0 x1=1
    // Row 10 col 00:  x4=1 x3=0 x2=0 x1=0
    // Row 10 col 01:  x4=1 x3=0 x2=0 x1=1

    // Simplify groups from the K-map (using don’t-cares to form groups):
    // Group 1: row 11 and 10, col 00 and 01 all 1 (4 cells)
    // f = x4 & ~x2

    // Group 2: row 11 col 01 and 01 col 11
    // More precisely, cells (0111) and (1110),(1111) are d or 0, so group 2 minimal
    // Single minterm: ~x4 & x3 & x2 & x1

    // Thus, minimal expression:
    // f = (x4 & ~x2) | (~x4 & x3 & x2 & x1)

    assign f = (x4 & ~x2) | (~x4 & x3 & x2 & x1);

endmodule