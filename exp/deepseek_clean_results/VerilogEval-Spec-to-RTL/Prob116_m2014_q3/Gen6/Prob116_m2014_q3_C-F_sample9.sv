module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Optimized intermediate signals
    wire term1 = x[2] & ~x[0];          // Covers x[4]x[3]=11/10 with x[2]x[1]=00/01
    wire term2 = x[3] & x[0] & x[1];    // Simplified term2 (x[2] is 0 implied by K-map)
    
    // Final output with x[2] check for term2
    assign f = term1 | (~x[2] & term2);
endmodule