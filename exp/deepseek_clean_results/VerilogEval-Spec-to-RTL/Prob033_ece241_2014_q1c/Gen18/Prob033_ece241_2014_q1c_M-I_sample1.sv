module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // 4-bit CLA for lower bits [3:0]
    wire [3:0] p0 = a[3:0] ^ b[3:0];
    wire [3:0] g0 = a[3:0] & b[3:0];
    wire [3:0] c0;
    
    assign c0[0] = g0[0] | (p0[0] & 1'b0);
    assign c0[1] = g0[1] | (p0[1] & g0[0]) | (p0[1] & p0[0] & 1'b0);
    assign c0[2] = g0[2] | (p0[2] & g0[1]) | (p0[2] & p0[1] & g0[0]) | (p0[2] & p0[1] & p0[0] & 1'b0);
    assign c0[3] = g0[3] | (p0[3] & g0[2]) | (p0[3] & p0[2] & g0[1]) | (p0[3] & p0[2] & p0[1] & g0[0]) | 
                  (p0[3] & p0[2] & p0[1] & p0[0] & 1'b0);
    
    // 4-bit CLA for upper bits [7:4]
    wire [3:0] p1 = a[7:4] ^ b[7:4];
    wire [3:0] g1 = a[7:4] & b[7:4];
    wire [3:0] c1;
    
    // Block generate/propagate for upper bits
    wire g_block = g1[3] | (p1[3] & g1[2]) | (p1[3] & p1[2] & g1[1]) | (p1[3] & p1[2] & p1[1] & g1[0]);
    wire p_block = p1[3] & p1[2] & p1[1] & p1[0];
    
    // Carry-in for upper bits
    wire cin_upper = g0[3] | (p0[3] & g0[2]) | (p0[3] & p0[2] & g0[1]) | (p0[3] & p0[2] & p0[1] & g0[0]) | 
                    (p0[3] & p0[2] & p0[1] & p0[0] & 1'b0);
    
    assign c1[0] = g1[0] | (p1[0] & cin_upper);
    assign c1[1] = g1[1] | (p1[1] & g1[0]) | (p1[1] & p1[0] & cin_upper);
    assign c1[2] = g1[2] | (p1[2] & g1[1]) | (p1[2] & p1[1] & g1[0]) | (p1[2] & p1[1] & p1[0] & cin_upper);
    assign c1[3] = g_block | (p_block & cin_upper);
    
    // Sum computation
    assign s[3:0] = p0 ^ {c0[2:0], 1'b0};
    assign s[7:4] = p1 ^ {c1[2:0], cin_upper};
    
    // Overflow detection (carry into MSB != carry out of MSB)
    assign overflow = c1[3] ^ c1[2];
endmodule