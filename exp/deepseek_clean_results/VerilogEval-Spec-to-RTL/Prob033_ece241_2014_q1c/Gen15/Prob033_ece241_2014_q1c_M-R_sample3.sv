module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] p, g;
    assign p = a ^ b;
    assign g = a & b;

    // Carry computation
    wire [7:0] c;
    
    // Bit 0 carry (no incoming carry)
    and g0_carry(g0, a[0], b[0]);
    assign c[0] = g0;
    
    // Bit 1 carry
    and g1_carry(g1, a[1], b[1]);
    and p1_g0(p1g0, p[1], g0);
    or  c1_or(c[1], g1, p1g0);
    
    // Bit 2 carry (shared intermediate)
    and g2_carry(g2, a[2], b[2]);
    and p2_c1(p2c1, p[2], c[1]);
    or  c2_or(c[2], g2, p2c1);
    
    // Bit 3 carry
    and g3_carry(g3, a[3], b[3]);
    and p3_c2(p3c2, p[3], c[2]);
    or  c3_or(c[3], g3, p3c2);
    
    // Bit 4 carry
    and g4_carry(g4, a[4], b[4]);
    and p4_c3(p4c3, p[4], c[3]);
    or  c4_or(c[4], g4, p4c3);
    
    // Bit 5 carry (shared intermediate)
    and g5_carry(g5, a[5], b[5]);
    and p5_c4(p5c4, p[5], c[4]);
    or  c5_or(c[5], g5, p5c4);
    
    // Bit 6 carry
    and g6_carry(g6, a[6], b[6]);
    and p6_c5(p6c5, p[6], c[5]);
    or  c6_or(c[6], g6, p6c5);
    
    // Bit 7 carry
    and g7_carry(g7, a[7], b[7]);
    and p7_c6(p7c6, p[7], c[6]);
    or  c7_or(c[7], g7, p7c6);

    // Sum computation
    assign s[0] = p[0];
    assign s[1] = p[1] ^ c[0];
    assign s[2] = p[2] ^ c[1];
    assign s[3] = p[3] ^ c[2];
    assign s[4] = p[4] ^ c[3];
    assign s[5] = p[5] ^ c[4];
    assign s[6] = p[6] ^ c[5];
    assign s[7] = p[7] ^ c[6];

    // Overflow detection
    wire same_sign, diff_result;
    xnor sign_comp(same_sign, a[7], b[7]);
    xor res_comp(diff_result, s[7], a[7]);
    and ovf_check(overflow, same_sign, diff_result);
endmodule