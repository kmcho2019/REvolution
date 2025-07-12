module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // First level prefix computation
    wire [7:0] g1, p1;
    assign g1[0] = g[0];
    assign p1[0] = p[0];
    
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : prefix_level1
            assign g1[i] = g[i] | (p[i] & g[i-1]);
            assign p1[i] = p[i] & p[i-1];
        end
    endgenerate
    
    // Second level prefix computation (Brent-Kung structure)
    wire [7:0] g2, p2;
    assign g2[0] = g1[0];
    assign p2[0] = p1[0];
    assign g2[1] = g1[1];
    assign p2[1] = p1[1];
    
    for (i = 2; i < 8; i = i + 2) begin : prefix_level2
        assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
        assign p2[i] = p1[i] & p1[i-2];
        if (i+1 < 8) begin
            assign g2[i+1] = g1[i+1] | (p1[i+1] & g1[i-1]);
            assign p2[i+1] = p1[i+1] & p1[i-1];
        end
    end
    
    // Final carry computation
    wire [7:0] c;
    assign c[0] = g[0];
    assign c[1] = g2[1];
    for (i = 2; i < 8; i = i + 1) begin : final_carry
        assign c[i] = g2[i] | (p2[i] & c[i-1]);
    end
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Early overflow detection (computed in parallel)
    wire same_sign = ~(a[7] ^ b[7]);
    wire sum_sign_diff = s[7] ^ a[7];
    assign overflow = same_sign & sum_sign_diff;
endmodule