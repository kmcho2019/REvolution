module TopModule(
    input [3:0] x,  // x[3:0] maps to [x4,x3,x2,x1] per K-map
    output f
);
    /* K-map reference (x4x3 vs x2x1):
       00  01  11  10
    00 | d | 0 | d | d |
    01 | 0 | d | 1 | 0 |
    11 | 1 | 1 | d | d |
    10 | 1 | 1 | 0 | d |
    
    Optimized implementation:
    - term1: x2 & ~x1 (covers all 0-1 transitions)
    - term2: x4 & x3 & x1 (covers all 1-1 cases)
    - Don't-cares used to minimize terms
    */
    assign f = (x[2] & ~x[0]) |  // term1: more frequent case first
               (x[3] & x[1] & x[0]); // term2: ANDs ordered by expected activity
endmodule