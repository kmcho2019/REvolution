module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Carry computation with 2-bit blocks
    wire [7:0] c;
    
    // Block 0-1
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & g[0]);
    
    // Block 2-3
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & (g[2] | (p[2] & c[1])));
    
    // Block 4-5
    assign c[4] = g[4] | (p[4] & c[3]);
    assign c[5] = g[5] | (p[5] & (g[4] | (p[4] & c[3])));
    
    // Block 6-7
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = g[7] | (p[7] & (g[6] | (p[6] & c[5])));
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Overflow detection (carry into MSB != carry out of MSB)
    assign overflow = c[7] ^ c[6];
endmodule