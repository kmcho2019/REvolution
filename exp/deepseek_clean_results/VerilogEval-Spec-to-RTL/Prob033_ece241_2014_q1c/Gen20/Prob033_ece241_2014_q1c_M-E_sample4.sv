module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower 4-bit ripple-carry adder
    wire [3:0] p_lo = a[3:0] ^ b[3:0];
    wire [3:0] g_lo = a[3:0] & b[3:0];
    
    wire c1 = g_lo[0] | (p_lo[0] & 1'b0);
    wire c2 = g_lo[1] | (p_lo[1] & c1);
    wire c3 = g_lo[2] | (p_lo[2] & c2);
    wire c4 = g_lo[3] | (p_lo[3] & c3);  // carry out from lower nibble
    
    wire [3:0] s_lo = p_lo ^ {c3, c2, c1, 1'b0};
    
    // Upper 4-bit carry-select adder
    wire [3:0] p_hi = a[7:4] ^ b[7:4];
    wire [3:0] g_hi = a[7:4] & b[7:4];
    
    // Case 1: carry-in = 0
    wire c5_0 = g_hi[0] | (p_hi[0] & 1'b0);
    wire c6_0 = g_hi[1] | (p_hi[1] & c5_0);
    wire c7_0 = g_hi[2] | (p_hi[2] & c6_0);
    wire c8_0 = g_hi[3] | (p_hi[3] & c7_0);
    wire [3:0] s_hi_0 = p_hi ^ {c7_0, c6_0, c5_0, 1'b0};
    
    // Case 2: carry-in = 1
    wire c5_1 = g_hi[0] | (p_hi[0] & 1'b1);
    wire c6_1 = g_hi[1] | (p_hi[1] & c5_1);
    wire c7_1 = g_hi[2] | (p_hi[2] & c6_1);
    wire c8_1 = g_hi[3] | (p_hi[3] & c7_1);
    wire [3:0] s_hi_1 = p_hi ^ {c7_1, c6_1, c5_1, 1'b1};
    
    // Select upper result based on lower carry-out
    wire [3:0] s_hi = c4 ? s_hi_1 : s_hi_0;
    wire c_out = c4 ? c8_1 : c8_0;
    
    // Combine results
    assign s = {s_hi, s_lo};
    
    // Overflow detection: inputs have same sign but result has different sign
    assign overflow = ~(a[7] ^ b[7]) & (a[7] ^ s[7]);
endmodule