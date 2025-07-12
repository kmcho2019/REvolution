module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    // Propagate and generate signals for each bit
    wire [7:0] p = a ^ b; // propagate
    wire [7:0] g = a & b; // generate

    // Group propagate and generate signals for nibbles (4 bits each)
    wire p_group0 = &p[3:0];      // propagate for bits 0-3
    wire p_group1 = &p[7:4];      // propagate for bits 4-7
    wire g_group0 = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & g[0])))));
    wire g_group1 = g[7] | (p[7] & (g[6] | (p[6] & (g[5] | (p[5] & g[4])))));

    // Calculate carries using carry-lookahead for 8 bits in two stages
    wire c0 = 1'b0; // carry-in is 0
    wire c4 = g_group0 | (p_group0 & c0);
    wire c8 = g_group1 | (p_group1 & c4);

    // Calculate carries for bits 1 to 7:
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g[1] | (p[1] & c1);
    wire c3 = g[2] | (p[2] & c2);
    wire c5 = g[4] | (p[4] & c4);
    wire c6 = g[5] | (p[5] & c5);
    wire c7 = g[6] | (p[6] & c6);

    // Assign carry vector for sum calculation
    wire [8:0] c = {c8, c7, c6, c5, c4, c3, c2, c1, c0};

    // Calculate sum bits
    assign s = p ^ c[7:0];

    // Overflow detection (signed addition overflow):
    // Overflow if a[7] == b[7] and s[7] != a[7]
    assign overflow = (~(a[7] ^ b[7])) & (a[7] ^ s[7]);

endmodule