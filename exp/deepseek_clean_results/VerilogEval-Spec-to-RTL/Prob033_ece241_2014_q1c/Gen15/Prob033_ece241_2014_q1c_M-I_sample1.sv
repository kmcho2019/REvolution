module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Grouped propagate and generate terms
    wire [1:0] p0, g0;  // bits 0-1
    wire [1:0] p1, g1;  // bits 2-3
    wire [1:0] p2, g2;  // bits 4-5
    wire [1:0] p3, g3;  // bits 6-7
    
    // Intermediate carries
    wire c0, c1, c2, c3, c4, c5, c6, c7;
    wire c1_3, c5_7;  // Block carries
    
    // First 4-bit block (bits 0-3)
    assign p0 = a[1:0] ^ b[1:0];
    assign g0 = a[1:0] & b[1:0];
    
    assign c0 = g0[0];
    assign c1 = g0[1] | (p0[1] & c0);
    
    assign p1 = a[3:2] ^ b[3:2];
    assign g1 = a[3:2] & b[3:2];
    
    assign c2 = g1[0] | (p1[0] & c1);
    assign c3 = g1[1] | (p1[1] & c2);
    assign c1_3 = c3;  // Save block carry
    
    // Second 4-bit block (bits 4-7)
    assign p2 = a[5:4] ^ b[5:4];
    assign g2 = a[5:4] & b[5:4];
    
    assign c4 = g2[0] | (p2[0] & c1_3);
    assign c5 = g2[1] | (p2[1] & c4);
    
    assign p3 = a[7:6] ^ b[7:6];
    assign g3 = a[7:6] & b[7:6];
    
    assign c6 = g3[0] | (p3[0] & c5);
    assign c7 = g3[1] | (p3[1] & c6);
    assign c5_7 = c7;  // Save block carry
    
    // Sum computation
    assign s[0] = p0[0];
    assign s[1] = p0[1] ^ c0;
    assign s[2] = p1[0] ^ c1;
    assign s[3] = p1[1] ^ c2;
    assign s[4] = p2[0] ^ c3;
    assign s[5] = p2[1] ^ c4;
    assign s[6] = p3[0] ^ c5;
    assign s[7] = p3[1] ^ c6;
    
    // Overflow detection (computed in parallel)
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_sum = s[7];
    assign overflow = (sign_a == sign_b) & (sign_sum != sign_a);
endmodule