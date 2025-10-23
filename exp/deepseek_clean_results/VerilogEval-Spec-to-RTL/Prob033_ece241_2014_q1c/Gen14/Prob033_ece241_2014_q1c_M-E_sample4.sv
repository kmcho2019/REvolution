module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit ripple-carry adder
    wire [3:0] g_lo = a[3:0] & b[3:0];
    wire [3:0] p_lo = a[3:0] ^ b[3:0];
    wire [3:0] c_lo;
    
    assign c_lo[0] = g_lo[0];
    assign c_lo[1] = g_lo[1] | (p_lo[1] & c_lo[0]);
    assign c_lo[2] = g_lo[2] | (p_lo[2] & c_lo[1]);
    assign c_lo[3] = g_lo[3] | (p_lo[3] & c_lo[2]);
    
    wire [3:0] s_lo = p_lo ^ {c_lo[2:0], 1'b0};
    
    // Upper 4-bit carry-select adder
    wire [3:0] g_hi = a[7:4] & b[7:4];
    wire [3:0] p_hi = a[7:4] ^ b[7:4];
    
    // Compute for carry-in = 0
    wire [3:0] c_hi0;
    assign c_hi0[0] = g_hi[0];
    assign c_hi0[1] = g_hi[1] | (p_hi[1] & c_hi0[0]);
    assign c_hi0[2] = g_hi[2] | (p_hi[2] & c_hi0[1]);
    assign c_hi0[3] = g_hi[3] | (p_hi[3] & c_hi0[2]);
    wire [3:0] s_hi0 = p_hi ^ {c_hi0[2:0], 1'b0};
    
    // Compute for carry-in = 1
    wire [3:0] c_hi1;
    assign c_hi1[0] = g_hi[0] | p_hi[0];
    assign c_hi1[1] = g_hi[1] | (p_hi[1] & c_hi1[0]);
    assign c_hi1[2] = g_hi[2] | (p_hi[2] & c_hi1[1]);
    assign c_hi1[3] = g_hi[3] | (p_hi[3] & c_hi1[2]);
    wire [3:0] s_hi1 = p_hi ^ {c_hi1[2:0], 1'b1};
    
    // Select upper result based on lower carry-out
    wire [3:0] s_hi = c_lo[3] ? s_hi1 : s_hi0;
    wire c_out = c_lo[3] ? c_hi1[3] : c_hi0[3];
    
    // Combine results
    assign s = {s_hi, s_lo};
    
    // Overflow detection
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);
endmodule