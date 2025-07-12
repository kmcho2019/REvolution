module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // First term: ~x[0] & x[2]
    wire term1 = ~x[0] & x[2];
    
    // Second term: x[0] & x[1] & x[3]
    wire term2 = x[0] & x[1] & x[3];
    
    // Final output
    assign f = term1 | term2;
endmodule