module TopModule(
    input [3:0] x,
    output f
);
    // First row cases (x[3]x[2] = 00)
    wire term1 = ~x[3] & ~x[2] & ~x[1] & ~x[0];  // 0000
    wire term2 = ~x[3] & ~x[2] & x[1] & ~x[0];   // 0010
    
    // Third row cases (x[3]x[2] = 11)
    wire term3 = x[3] & x[2] & ~x[1] & ~x[0];     // 1100
    wire term4 = x[3] & x[2] & ~x[1] & x[0];      // 1101
    wire term5 = x[3] & x[2] & x[1] & x[0];       // 1111
    
    // Fourth row cases (x[3]x[2] = 10)
    wire term6 = x[3] & ~x[2] & ~x[1] & ~x[0];    // 1000
    wire term7 = x[3] & ~x[2] & ~x[1] & x[0];     // 1001
    wire term8 = x[3] & ~x[2] & x[1] & ~x[0];     // 1010
    
    // Combine all terms with OR gates
    assign f = term1 | term2 | term3 | term4 | term5 | term6 | term7 | term8;
endmodule