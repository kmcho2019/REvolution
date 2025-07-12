module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Lower nibble (bits 0-3) - ripple carry
    wire [3:0] p_lo = a[3:0] ^ b[3:0];
    wire [3:0] g_lo = a[3:0] & b[3:0];
    wire [3:0] c_lo;
    
    assign c_lo[0] = g_lo[0];
    assign c_lo[1] = g_lo[1] | (p_lo[1] & c_lo[0]);
    assign c_lo[2] = g_lo[2] | (p_lo[2] & c_lo[1]);
    assign c_lo[3] = g_lo[3] | (p_lo[3] & c_lo[2]);
    
    wire [3:0] s_lo = p_lo ^ {c_lo[2:0], 1'b0};
    
    // Upper nibble - carry-select (compute both possibilities)
    wire [3:0] p_hi = a[7:4] ^ b[7:4];
    wire [3:0] g_hi = a[7:4] & b[7:4];
    
    // Case 1: carry_in = 0
    wire [3:0] c_hi0;
    assign c_hi0[0] = g_hi[0];
    assign c_hi0[1] = g_hi[1] | (p_hi[1] & c_hi0[0]);
    assign c_hi0[2] = g_hi[2] | (p_hi[2] & c_hi0[1]);
    assign c_hi0[3] = g_hi[3] | (p_hi[3] & c_hi0[2]);
    wire [3:0] s_hi0 = p_hi ^ {c_hi0[2:0], 1'b0};
    
    // Case 2: carry_in = 1
    wire [3:0] c_hi1;
    assign c_hi1[0] = g_hi[0] | p_hi[0];
    assign c_hi1[1] = g_hi[1] | (p_hi[1] & c_hi1[0]);
    assign c_hi1[2] = g_hi[2] | (p_hi[2] & c_hi1[1]);
    assign c_hi1[3] = g_hi[3] | (p_hi[3] & c_hi1[2]);
    wire [3:0] s_hi1 = p_hi ^ {c_hi1[2:0], 1'b0};
    
    // Final selection and overflow detection
    wire carry_select = c_lo[3];
    assign s = {carry_select ? s_hi1 : s_hi0, s_lo};
    
    // Overflow occurs if:
    // 1. Both inputs are positive but result is negative (carry_select=0, s_hi0[3]=1)
    // 2. Both inputs are negative but result is positive (carry_select=1, s_hi1[3]=0)
    wire both_pos = ~a[7] & ~b[7];
    wire both_neg = a[7] & b[7];
    wire ovf_case0 = both_pos & s_hi0[3] & ~carry_select;
    wire ovf_case1 = both_neg & ~s_hi1[3] & carry_select;
    assign overflow = ovf_case0 | ovf_case1;
endmodule