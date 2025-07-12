module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Stage 1: 4-bit Kogge-Stone blocks
    wire [3:0] p0, g0, c0;
    wire [3:0] p1, g1, c1;
    
    // Block 0 (bits 0-3)
    prefix_block_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .p(p0),
        .g(g0),
        .c(c0)
    );
    
    // Block 1 (bits 4-7)
    prefix_block_4bit block1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .p(p1),
        .g(g1),
        .c(c1)
    );
    
    // Stage 2: Brent-Kung style global carry network
    wire g4_7, p4_7;
    wire c4;
    
    // Global propagate/generate
    and pg_global_p(p4_7, p1[3], p0[3]);
    and pg_global_g(g4_7, g1[3], (p1[3] & g0[3]));
    
    // Carry between blocks
    assign c4 = g0[3] | (p0[3] & 1'b0); // No cin
    
    // Final carries
    wire [7:0] carry;
    assign carry[3:0] = c0;
    assign carry[7:4] = {c1[3] | (p1[3] & c4),
                        c1[2] | (p1[2] & c4),
                        c1[1] | (p1[1] & c4),
                        c1[0] | (p1[0] & c4)};
    
    // Sum computation
    assign s = (a ^ b) ^ {carry[6:0], 1'b0};
    
    // Early overflow detection
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire sign_sum = s[7];
    wire carry_in = carry[6];
    wire carry_out = carry[7];
    
    // Overflow occurs if:
    // 1. Both inputs are negative and result is non-negative (with carry)
    // 2. Both inputs are positive and result is negative (no carry)
    assign overflow = (sign_a & sign_b & ~sign_sum) |
                     (~sign_a & ~sign_b & sign_sum) |
                     (sign_a == sign_b & carry_in != carry_out);
endmodule

module prefix_block_4bit(
    input [3:0] a,
    input [3:0] b,
    output [3:0] p,
    output [3:0] g,
    output [3:0] c
);
    // Generate and propagate
    assign p = a ^ b;
    assign g = a & b;
    
    // Prefix tree (Kogge-Stone)
    wire [3:0] g1, p1;
    wire [3:0] g2, p2;
    
    // First level
    assign g1[0] = g[0];
    assign p1[0] = p[0];
    assign g1[1] = g[1] | (p[1] & g[0]);
    assign p1[1] = p[1] & p[0];
    assign g1[2] = g[2] | (p[2] & g[1]);
    assign p1[2] = p[2] & p[1];
    assign g1[3] = g[3] | (p[3] & g[2]);
    assign p1[3] = p[3] & p[2];
    
    // Second level
    assign g2[0] = g1[0];
    assign p2[0] = p1[0];
    assign g2[1] = g1[1];
    assign p2[1] = p1[1];
    assign g2[2] = g1[2] | (p1[2] & g1[0]);
    assign p2[2] = p1[2] & p1[0];
    assign g2[3] = g1[3] | (p1[3] & g1[1]);
    assign p2[3] = p1[3] & p1[1];
    
    // Final carries
    assign c[0] = g[0];
    assign c[1] = g1[1];
    assign c[2] = g2[2];
    assign c[3] = g2[3] | (p2[3] & g2[1]);
endmodule