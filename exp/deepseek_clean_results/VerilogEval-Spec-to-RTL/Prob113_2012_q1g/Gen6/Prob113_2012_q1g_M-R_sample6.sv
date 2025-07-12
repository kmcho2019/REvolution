module TopModule(
    input [3:0] x,
    output f
);
    // Break down into distinct product terms for clarity
    wire term1 = ~x[3] & ~x[2] & ~x[0];  // Covers 0000, 0010
    wire term2 = x[3] & x[2] & ~x[1];     // Covers 1100
    wire term3 = x[3] & x[2] & x[0];      // Covers 1101, 1111
    wire term4 = x[3] & ~x[2] & ~x[1];    // Covers 1000, 1001
    wire term5 = x[3] & ~x[2] & x[0];     // Covers 1010
    
    assign f = term1 | term2 | term3 | term4 | term5;
endmodule