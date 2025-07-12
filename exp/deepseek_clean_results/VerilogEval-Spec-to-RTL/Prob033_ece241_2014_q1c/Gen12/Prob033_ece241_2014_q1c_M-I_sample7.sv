module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Group generate/propagate terms for better carry lookahead
    wire [7:0] g_group, p_group;
    assign g_group[0] = g[0];
    assign p_group[0] = p[0];
    
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : carry_lookahead
            assign g_group[i] = g[i] | (p[i] & g_group[i-1]);
            assign p_group[i] = p[i] & p_group[i-1];
        end
    endgenerate
    
    // Carry computation using group terms
    wire [7:0] c;
    assign c[0] = g[0];
    generate
        for (i = 1; i < 8; i = i + 1) begin : carry_compute
            assign c[i] = g_group[i-1] | (p_group[i-1] & c[0]);
        end
    endgenerate
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Early overflow detection using carry[7] and sign bits
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule