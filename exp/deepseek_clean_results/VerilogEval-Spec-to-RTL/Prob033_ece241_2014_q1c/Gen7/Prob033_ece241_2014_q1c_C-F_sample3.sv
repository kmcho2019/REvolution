module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // 4-bit block carry-lookahead structure
    wire [1:0] g_block, p_block;
    wire [1:0] c_block;
    
    // First 4-bit block
    wire [3:0] g_low = a[3:0] & b[3:0];
    wire [3:0] p_low = a[3:0] ^ b[3:0];
    wire [3:0] c_low;
    
    assign c_low[0] = g_low[0];
    assign c_low[1] = g_low[1] | (p_low[1] & c_low[0]);
    assign c_low[2] = g_low[2] | (p_low[2] & c_low[1]);
    assign c_low[3] = g_low[3] | (p_low[3] & c_low[2]);
    
    assign g_block[0] = g_low[3] | (p_low[3] & (g_low[2] | (p_low[2] & (g_low[1] | (p_low[1] & g_low[0]))));
    assign p_block[0] = &p_low;
    
    // Second 4-bit block
    wire [3:0] g_high = a[7:4] & b[7:4];
    wire [3:0] p_high = a[7:4] ^ b[7:4];
    wire [3:0] c_high;
    
    assign c_high[0] = g_high[0] | (p_high[0] & c_block[0]);
    assign c_high[1] = g_high[1] | (p_high[1] & c_high[0]);
    assign c_high[2] = g_high[2] | (p_high[2] & c_high[1]);
    assign c_high[3] = g_high[3] | (p_high[3] & c_high[2]);
    
    assign g_block[1] = g_high[3] | (p_high[3] & (g_high[2] | (p_high[2] & (g_high[1] | (p_high[1] & g_high[0]))));
    assign p_block[1] = &p_high;
    
    // Block carry computation
    assign c_block[0] = g_block[0];
    assign c_block[1] = g_block[1] | (p_block[1] & c_block[0]);
    
    // Final sum computation
    assign s[3:0] = p_low ^ {c_low[2:0], 1'b0};
    assign s[7:4] = p_high ^ c_high;
    
    // Optimized overflow detection
    wire signs_differ = a[7] ^ b[7];
    assign overflow = ~signs_differ & (a[7] ^ s[7]);
endmodule