module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit block (bits 3:0)
    wire [3:0] g_lo = a[3:0] & b[3:0];
    wire [3:0] p_lo = a[3:0] ^ b[3:0];
    
    wire [3:0] c_lo;
    assign c_lo[0] = g_lo[0];
    assign c_lo[1] = g_lo[1] | (p_lo[1] & c_lo[0]);
    assign c_lo[2] = g_lo[2] | (p_lo[2] & c_lo[1]);
    assign c_lo[3] = g_lo[3] | (p_lo[3] & c_lo[2]);
    
    wire p_block_lo = &p_lo;  // Block propagate for lower 4 bits
    
    // Upper 4-bit block (bits 7:4)
    wire [3:0] g_hi = a[7:4] & b[7:4];
    wire [3:0] p_hi = a[7:4] ^ b[7:4];
    
    wire [3:0] c_hi;
    wire cin_hi = p_block_lo ? c_lo[3] : g_lo[3];  // Carry-skip logic
    
    assign c_hi[0] = g_hi[0] | (p_hi[0] & cin_hi);
    assign c_hi[1] = g_hi[1] | (p_hi[1] & c_hi[0]);
    assign c_hi[2] = g_hi[2] | (p_hi[2] & c_hi[1]);
    assign c_hi[3] = g_hi[3] | (p_hi[3] & c_hi[2]);
    
    // Sum computation
    assign s[3:0] = p_lo ^ {c_lo[2:0], 1'b0};
    assign s[7:4] = p_hi ^ {c_hi[2:0], cin_hi};
    
    // Overflow detection (early detection using MSB block)
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_s = s[7];
    assign overflow = (sign_a == sign_b) & (sign_s != sign_a);
endmodule