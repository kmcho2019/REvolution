module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    wire term1 = x[2] & ~x[0];      // First condition from K-map
    wire term2 = x[3] & x[0] & x[1]; // Second condition from K-map
    
    assign f = term1 | term2;       // Combine terms
endmodule