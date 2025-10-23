module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    // Optimized implementation using minimal 2 gates:
    // f = (x[3] & x[1]) | (x[2] & ~x[0])
    // K-map coverage:
    // x[1]x[2]  00  01  11  10
    // x[3]x[4] ---------------
    //      00 | d | 0 | d | d |
    //      01 | 0 | d | 1 | 0 |  (x[3]&x[1] covers the 1)
    //      11 | 1 | 1 | d | d |  (x[3]&x[1] covers both 1s)
    //      10 | 1 | 1 | 0 | d |  (x[2]&~x[0] covers both 1s)
    assign f = (x[3] & x[1]) | (x[2] & ~x[0]);
endmodule