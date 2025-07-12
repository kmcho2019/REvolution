module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // 4-bit carry-lookahead blocks for better timing
    wire [1:0] g_block, p_block;
    wire [1:0] c_block;
    
    // Generate and propagate for each 4-bit block
    assign g_block[0] = (a[3] & b[3]) | ((a[3] ^ b[3]) & (a[2] & b[2])) |
                       ((a[3] ^ b[3]) & (a[2] ^ b[2]) & (a[1] & b[1])) |
                       ((a[3] ^ b[3]) & (a[2] ^ b[2]) & (a[1] ^ b[1]) & (a[0] & b[0]));
    
    assign p_block[0] = (a[3] ^ b[3]) & (a[2] ^ b[2]) & (a[1] ^ b[1]) & (a[0] ^ b[0]);
    
    assign g_block[1] = (a[7] & b[7]) | ((a[7] ^ b[7]) & (a[6] & b[6])) |
                       ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] & b[5])) |
                       ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] ^ b[5]) & (a[4] & b[4]));
    
    assign p_block[1] = (a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] ^ b[5]) & (a[4] ^ b[4]);
    
    // Block carries
    assign c_block[0] = g_block[0];
    assign c_block[1] = g_block[1] | (p_block[1] & g_block[0]);
    
    // Final sum calculation
    assign s[3:0] = (a[3:0] ^ b[3:0]) ^ {c_block[0], 3'b0};
    assign s[7:4] = (a[7:4] ^ b[7:4]) ^ {c_block[1], 3'b0};
    
    // Efficient overflow detection (shared with MSB calculation)
    assign overflow = (a[7] == b[7]) && (s[7] != a[7]);
endmodule