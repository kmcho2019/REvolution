module TopModule(
    input [3:0] x,
    output f
);
    wire term1, term2, term3, term4;
    
    // Group 1: x3x2'x1' (covers 0000 and 1000)
    assign term1 = x[3] & ~x[2] & ~x[1];
    
    // Group 2: x3x2x0' (covers 1100 and 1101)
    assign term2 = x[3] & x[2] & ~x[0];
    
    // Group 3: x3'x2'x0' (covers 0000 and 0010)
    assign term3 = ~x[3] & ~x[2] & ~x[0];
    
    // Group 4: x3x2x1 (covers 1111)
    assign term4 = x[3] & x[2] & x[1];
    
    // Combine all terms
    assign f = term1 | term2 | term3 | term4;
endmodule