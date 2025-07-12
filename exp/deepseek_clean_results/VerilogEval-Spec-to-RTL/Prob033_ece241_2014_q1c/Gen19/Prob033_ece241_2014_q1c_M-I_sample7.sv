module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Carry computation using 4-bit blocks
    wire [7:0] c;
    
    // First carry bit
    assign c[0] = g[0];
    
    // First 4-bit block
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & c[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & c[0]);
    
    // Second 4-bit block
    assign c[4] = g[4] | (p[4] & c[3]);
    assign c[5] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & c[3]);
    assign c[6] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & c[3]);
    assign c[7] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]) | 
                 (p[7] & p[6] & p[5] & p[4] & c[3]);
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Optimized overflow detection
    assign overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);
endmodule