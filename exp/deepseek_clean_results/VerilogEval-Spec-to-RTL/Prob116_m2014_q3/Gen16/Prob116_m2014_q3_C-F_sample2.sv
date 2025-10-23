module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    // f = (~x[0] & x[2]) | (x[0] & x[1] & x[3]) from K-map:
    // x[1]x[2]  00  01  11  10
    // x[3]x[4] ---------------
    //      00 | d | 0 | d | d |
    //      01 | 0 | d | 1 | 0 |
    //      11 | 1 | 1 | d | d |
    //      10 | 1 | 1 | 0 | d |
    assign f = (~x[0] & x[2]) |  // First term covers 0-1 transitions
               (x[0] & x[1] & x[3]);  // Second term covers 1-1 cases
endmodule