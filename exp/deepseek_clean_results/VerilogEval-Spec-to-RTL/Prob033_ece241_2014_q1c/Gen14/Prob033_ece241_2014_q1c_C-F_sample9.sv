module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Hierarchical carry computation with optimized intermediate carries
    wire [7:0] c;
    wire c1, c3, c5;  // Shared intermediate carries
    
    // First block: bits 0-1
    assign c[0] = g[0];
    assign c1 = g[1] | (p[1] & c[0]);
    assign c[1] = c1;
    
    // Second block: bits 2-3
    assign c[2] = g[2] | (p[2] & c1);
    assign c3 = g[3] | (p[3] & c[2]);
    assign c[3] = c3;
    
    // Third block: bits 4-5
    assign c[4] = g[4] | (p[4] & c3);
    assign c5 = g[5] | (p[5] & c[4]);
    assign c[5] = c5;
    
    // Fourth block: bits 6-7
    assign c[6] = g[6] | (p[6] & c5);
    assign c[7] = g[7] | (p[7] & c[6]);
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Overflow detection (most reliable method)
    assign overflow = (a[7] == b[7]) ? (s[7] != a[7]) : (c[7] != c[6]);
endmodule