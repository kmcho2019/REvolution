module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    wire term1 = x[2] & ~x[0];       // First AND term (x[2] AND NOT x[0])
    wire term2 = x[3] & x[0] & x[1]; // Second AND term (x[3] AND x[0] AND x[1])
    
    assign f = term1 | term2;        // Combine terms with OR
endmodule