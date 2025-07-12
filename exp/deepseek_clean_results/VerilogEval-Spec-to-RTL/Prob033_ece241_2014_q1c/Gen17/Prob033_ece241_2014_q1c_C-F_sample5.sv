module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] p, g;
    wire [8:0] c;
    wire c3;  // Intermediate carry signal
    
    // Generate and propagate terms
    assign p = a ^ b;
    assign g = a & b;
    
    // First 4-bit block (bits 0-3)
    assign c[0] = 1'b0;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c3 = g[3] | (p[3] & c[3]);
    
    // Second 4-bit block (bits 4-7)
    assign c[4] = c3;
    genvar i;
    generate
        for (i = 4; i < 8; i = i + 1) begin : carry_chain
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate
    
    // Sum computation
    assign s = p ^ c[7:0];
    
    // Optimized overflow detection
    assign overflow = (a[7] == b[7]) & (s[7] != a[7]);
endmodule