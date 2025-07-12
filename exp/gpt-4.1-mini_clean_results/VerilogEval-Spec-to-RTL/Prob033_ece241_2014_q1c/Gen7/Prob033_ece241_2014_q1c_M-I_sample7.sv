module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;       // bit propagate and generate
    wire c0 = 1'b0;        // initial carry-in
    wire c4, c8;           // carry signals after lower and upper group

    // Group propagate and generate signals for lower nibble (bits 0-3)
    wire p_lower_group, g_lower_group;
    // Group propagate and generate signals for upper nibble (bits 4-7)
    wire p_upper_group, g_upper_group;

    // Assign bit propagate and generate
    assign p = a ^ b;
    assign g = a & b;

    // Compute group propagate and generate for lower nibble (bits 0-3)
    assign p_lower_group = &p[3:0];                           // all propagate bits ANDed
    assign g_lower_group = g[3] | (p[3] & g[2]) | (p[3]&p[2]&g[1]) | (p[3]&p[2]&p[1]&g[0]);

    // Compute group propagate and generate for upper nibble (bits 4-7)
    assign p_upper_group = &p[7:4];
    assign g_upper_group = g[7] | (p[7] & g[6]) | (p[7]&p[6]&g[5]) | (p[7]&p[6]&p[5]&g[4]);

    // Carry into bit 4 (c4): carry out of lower group
    assign c4 = g_lower_group | (p_lower_group & c0);

    // Carry into bit 8 (c8): carry out of upper group (final carry out)
    assign c8 = g_upper_group | (p_upper_group & c4);

    // Now compute carries c[1] to c[3] for bits 1..3 in lower group
    wire c1, c2, c3;
    assign c1 = g[0] | (p[0] & c0);
    assign c2 = g[1] | (p[1] & c1);
    assign c3 = g[2] | (p[2] & c2);

    // Compute carries c[5] to c[7] for upper group bits 5..7
    wire c5, c6, c7;
    assign c5 = g[4] | (p[4] & c4);
    assign c6 = g[5] | (p[5] & c5);
    assign c7 = g[6] | (p[6] & c6);

    // Assign sum bits: s[i] = p[i] XOR carry_in[i]
    assign s[0] = p[0] ^ c0;
    assign s[1] = p[1] ^ c1;
    assign s[2] = p[2] ^ c2;
    assign s[3] = p[3] ^ c3;
    assign s[4] = p[4] ^ c4;
    assign s[5] = p[5] ^ c5;
    assign s[6] = p[6] ^ c6;
    assign s[7] = p[7] ^ c7;

    // Overflow detection: XOR of carry into and out of MSB (bit 7)
    // carry into MSB is c7, carry out of MSB is c8
    assign overflow = c7 ^ c8;

endmodule