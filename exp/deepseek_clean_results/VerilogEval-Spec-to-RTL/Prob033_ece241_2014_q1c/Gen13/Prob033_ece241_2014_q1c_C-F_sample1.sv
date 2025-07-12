module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [7:0] p, g;
    wire [7:0] c;
    wire c2, c5;  // Shared intermediate carry signals
    
    // Generate and propagate terms
    assign p = a ^ b;
    assign g = a & b;
    
    // First level: bits 0-1
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & g[0]);
    
    // Second level: bits 2-4 with shared c2
    assign c2 = g[2] | (p[2] & c[1]);
    generate
        for (genvar i = 2; i < 5; i = i + 1) begin : carry_mid
            if (i == 2) assign c[i] = c2;
            else assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate
    
    // Third level: bits 5-7 with shared c5
    assign c5 = g[5] | (p[5] & c[4]);
    generate
        for (genvar i = 5; i < 8; i = i + 1) begin : carry_upper
            if (i == 5) assign c[i] = c5;
            else assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Overflow detection
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule