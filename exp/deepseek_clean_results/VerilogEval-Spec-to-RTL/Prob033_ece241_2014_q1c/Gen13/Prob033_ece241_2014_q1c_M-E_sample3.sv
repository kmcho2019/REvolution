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
        for (i = 1; i < 8; i = i + 1) begin : prefix1
            assign g1[i] = g[i] | (p[i] & g[i-1]);
            assign p1[i] = p[i] & p[i-1];
        end
    endgenerate
    
    // Second level prefix computation (skip some for 8-bit)
    wire [7:0] g2, p2;
    assign g2[1:0] = g1[1:0];
    assign p2[1:0] = p1[1:0];
    
    generate
        for (i = 2; i < 8; i = i + 1) begin : prefix2
            assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
            assign p2[i] = p1[i] & p1[i-2];
        end
    endgenerate
    
    // Final carry computation
    wire [7:0] c;
    assign c[0] = g[0];
    assign c[1] = g2[1];
    assign c[2] = g2[2];
    assign c[3] = g2[3] | (p2[3] & g2[1]);
    assign c[4] = g2[4];
    assign c[5] = g2[5] | (p2[5] & g2[3]);
    assign c[6] = g2[6] | (p2[6] & g2[4]);
    assign c[7] = g2[7] | (p2[7] & g2[5]);
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Early overflow detection using carry into and out of MSB
    wire carry_in_msb = c[6];
    wire carry_out = c[7];
    assign overflow = (a[7] == b[7]) ? (s[7] != a[7]) : (carry_out != carry_in_msb);
endmodule