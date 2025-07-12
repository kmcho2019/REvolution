module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    wire term1 = x[2] & ~x[0];      // First condition: x[2] high and x[0] low
    wire term2 = x[3] & x[0] & x[1]; // Second condition: x[3], x[0], and x[1] all high
    
    assign f = term1 | term2;       // Final output is OR of both terms
endmodule