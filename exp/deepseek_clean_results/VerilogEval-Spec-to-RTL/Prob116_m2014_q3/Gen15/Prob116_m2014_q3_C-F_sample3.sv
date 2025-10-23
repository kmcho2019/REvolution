module TopModule(
    input [3:0] x,  // x[3:0] maps to x[4:1] in K-map
    output f
);
    // NAND implementation with clear term separation
    wire term1 = ~(~x[0] & x[2]);          // Covers all cases where x[2]=1 and x[0]=0
    wire term2 = ~(x[0] & x[1] & x[3]);    // Covers remaining 1s in K-map
    
    // Final output combining terms
    assign f = ~(term1 & term2);
endmodule