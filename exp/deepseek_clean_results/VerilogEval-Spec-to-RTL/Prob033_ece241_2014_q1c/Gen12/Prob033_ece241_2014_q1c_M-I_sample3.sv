module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] p, g;
    wire [7:0] c;
    wire c2, c5;  // Intermediate carry signals
    
    // Generate and propagate terms
    assign p = a ^ b;
    assign g = a & b;
    
    // First level: bits 0-1
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & g[0]);
    
    // Second level: bits 2-4 (with shared intermediate c2)
    assign c2 = g[2] | (p[2] & c[1]);
    assign c[2] = c2;
    assign c[3] = g[3] | (p[3] & c2);
    assign c[4] = g[4] | (p[4] & c[3]);
    
    // Third level: bits 5-7 (with shared intermediate c5)
    assign c5 = g[5] | (p[5] & c[4]);
    assign c[5] = c5;
    assign c[6] = g[6] | (p[6] & c5);
    assign c[7] = g[7] | (p[7] & c[6]);
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Optimized overflow detection
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule