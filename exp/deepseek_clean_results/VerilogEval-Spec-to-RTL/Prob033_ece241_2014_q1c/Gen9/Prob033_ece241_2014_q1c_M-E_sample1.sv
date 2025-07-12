module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Stage 1: 4-bit group prefix computation
    wire [3:0] p_low = a[3:0] ^ b[3:0];
    wire [3:0] g_low = a[3:0] & b[3:0];
    wire [3:0] p_high = a[7:4] ^ b[7:4];
    wire [3:0] g_high = a[7:4] & b[7:4];
    
    // Group propagate and generate
    wire G0 = g_low[3] | (p_low[3] & (g_low[2] | (p_low[2] & (g_low[1] | (p_low[1] & g_low[0])))));
    wire P0 = p_low[3] & p_low[2] & p_low[1] & p_low[0];
    wire G1 = g_high[3] | (p_high[3] & (g_high[2] | (p_high[2] & (g_high[1] | (p_high[1] & g_high[0])))));
    wire P1 = p_high[3] & p_high[2] & p_high[1] & p_high[0];
    
    // Global carry computation with early overflow detection
    wire C4 = G0;
    wire C8 = G1 | (P1 & G0);
    
    // Overflow detection (computed in parallel)
    wire same_sign = ~(a[7] ^ b[7]);
    wire sum_sign = a[7] ^ b[7] ^ C8;
    assign overflow = same_sign & (sum_sign != a[7]);
    
    // Conditional carry propagation (power optimization)
    wire [3:0] c_low = {G0, (g_low[2] | (p_low[2] & g_low[1])), 
                     (g_low[1] | (p_low[1] & g_low[0])), g_low[0]};
    wire [3:0] c_high = overflow ? 4'b0 : 
                       {C8, (g_high[2] | (p_high[2] & g_high[1])), 
                        (g_high[1] | (p_high[1] & g_high[0])), g_high[0]};
    
    // Sum computation
    assign s[3:0] = p_low ^ {c_low[2:0], 1'b0};
    assign s[7:4] = p_high ^ {c_high[2:0], C4};
endmodule