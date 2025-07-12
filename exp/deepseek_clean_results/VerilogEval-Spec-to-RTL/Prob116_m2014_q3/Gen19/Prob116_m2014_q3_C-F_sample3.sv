module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] in K-map
    output f
);
    // K-map reference (x4x3 vs x2x1):
    //       00  01  11  10
    // 00 | d | 0 | d | d |
    // 01 | 0 | d | 1 | 0 |
    // 11 | 1 | 1 | d | d |
    // 10 | 1 | 1 | 0 | d |
    
    // Positive term covers all 1s in x4x3=1x regions
    wire pos_term = x[3] & x[1] & x[0];
    
    // Negative term covers isolated 1s when x4x3=00 and x2=1
    wire neg_term = ~x[0] & x[2];
    
    assign f = pos_term | neg_term;
endmodule