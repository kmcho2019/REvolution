module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0]
    output f
);
    // Optimized logic derived from K-map analysis
    assign f = (~x[3] & x[0] & x[1] & x[2]) |  // x3x0=01, x1x2=11
               (x[3] & ~x[0] & ~x[1] & ~x[2]) | // x3x0=10, x1x2=00
               (x[3] & ~x[1]) |                // Covers multiple 1s in x3x0=11 and 10
               (x[3] & x[0] & ~x[2]);          // x3x0=11, x1x2=01
endmodule