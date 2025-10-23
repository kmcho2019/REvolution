module TopModule (
    input  [3:0] x,
    output      f
);
    // Map bits: x = {x[3], x[2], x[1], x[0]} with
    // Karnaugh map indices:
    // rows = x[3]x[0], columns = x[2]x[1]
    // Given K-map:
    //          x[1]x[2]
    // x[3]x[0] 00  01  11  10
    //  00      d   0   d   d
    //  01      0   d   1   0
    //  11      1   1   d   d
    //  10      1   1   0   d

    // From the K-map, simplify with chosen don't-cares:
    // We will use:
    //   f = x[3]&~x[0] | x[3]&x[2] | x[0]&~x[1]&~x[2]

    assign f = (x[3] & ~x[0]) | (x[3] & x[2]) | (x[0] & ~x[1] & ~x[2]);

endmodule