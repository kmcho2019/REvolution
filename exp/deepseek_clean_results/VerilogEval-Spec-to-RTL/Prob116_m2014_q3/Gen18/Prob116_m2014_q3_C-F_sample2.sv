module TopModule(
    input [3:0] x,  // Input mapping: x[3:4] are K-map rows, x[1:2] are columns
    output f
);
    /* K-map reference (x[3]x[4] rows, x[1]x[2] columns):
        00  01  11  10
    00 | d | 0 | d | d |
    01 | 0 | d | 1 | 0 |
    11 | 1 | 1 | d | d |
    10 | 1 | 1 | 0 | d |
    */
    
    // Logic terms with descriptive names
    wire x2_notx0 = x[2] & ~x[0];      // Covers cases where x[2]=1 and x[0]=0
    wire x3_x0_x1 = x[3] & x[0] & x[1]; // Covers cases where all three are 1
    
    assign f = x2_notx0 | x3_x0_x1;    // Final OR combination of terms
endmodule