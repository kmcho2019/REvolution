module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Optimized terms using don't-care conditions more aggressively
    wire term1 = ~x[0] & x[2];          // Covers 0 in x[3]x[4]=01 and 1 in x[3]x[4]=00
    wire term2 = x[1] & (x[0] | x[3]);  // Simplified using don't-cares
    
    assign f = term1 | term2;
endmodule