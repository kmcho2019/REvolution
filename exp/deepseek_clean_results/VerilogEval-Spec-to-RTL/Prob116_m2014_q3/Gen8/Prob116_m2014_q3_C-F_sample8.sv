module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // Intermediate signals using simplified terms
    wire term1 = x[2] & ~x[0];          // Covers x[4]x[3]=11/10 with x[2]x[1]=00/01
    wire term2 = ~x[2] & x[0] & x[1];   // Simplified term for x[4]x[3]=01 with x[2]x[1]=11
    
    // Final output
    assign f = term1 | term2;
endmodule