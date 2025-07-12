module TopModule(
    input [3:0] x,  // x[3], x[2], x[1], x[0]
    output f
);
    // Product-of-sums implementation with corrected logic
    wire term1 = ~x[3] & ~x[0] & ~x[1] & x[2];  // Force 0 when x3x0=00, x1x2=01
    wire term2 = ~x[3] & x[0] & ~(x[1] & x[2]);  // Force 0 except when x1x2=11
    wire term3 = x[3] & ~x[0] & x[1] & ~x[2];    // Force 0 when x3x0=10, x1x2=10
    
    assign f = ~(term1 | term2 | term3);
endmodule