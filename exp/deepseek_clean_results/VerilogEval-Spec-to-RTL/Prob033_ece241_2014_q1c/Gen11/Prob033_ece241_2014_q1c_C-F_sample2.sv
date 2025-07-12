module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] g, p;
    wire [7:0] c;
    
    // Generate and propagate terms
    assign g = a & b;
    assign p = a ^ b;
    
    // Hierarchical carry computation using generate blocks
    // First 4-bit block
    assign c[0] = g[0];
    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : carry_low
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
        
        // Second 4-bit block (starts with carry from first block)
        assign c[4] = g[4] | (p[4] & c[3]);
        for (i = 5; i < 8; i = i + 1) begin : carry_high
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Overflow detection
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule