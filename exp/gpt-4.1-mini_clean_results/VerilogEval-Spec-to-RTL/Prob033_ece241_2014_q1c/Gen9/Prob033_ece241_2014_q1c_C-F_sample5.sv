module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output p,       // propagate = a ^ b
    output g        // generate  = a & b
);
    assign p = a ^ b;
    assign g = a & b;
    assign sum = p ^ cin;
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;       // propagate and generate from each bit
    wire [8:0] c;          // carry signals, c[0] = 0 initial carry-in

    assign c[0] = 1'b0;    // initial carry-in is zero

    // Instantiate full adders to produce sum and propagate/generate signals
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : full_adders
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(s[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Carry-lookahead logic for 8-bit adder:
    // We'll group bits into two groups of 4 bits each to reduce carry chain length:
    // Group 0: bits [3:0]
    // Group 1: bits [7:4]
    // Compute group propagate (GP) and group generate (GG):
    wire gp0, gg0, gp1, gg1;

    // Group propagate: AND of all p in the group
    assign gp0 = &p[3:0];
    assign gp1 = &p[7:4];

    // Group generate: g7 + p7*g6 + p7p6*g5 + p7p6p5*g4 (chain for bits 7 to 4)
    // Similarly for bits 3 to 0
    // We'll compute group generate as:
    // GG = g_msb + (p_msb & g_msb-1) + ... (carry-lookahead formula for group)

    // For group0 (bits 3 downto 0)
    wire g0_0 = g[0];
    wire g0_1 = g[1];
    wire g0_2 = g[2];
    wire g0_3 = g[3];
    wire p0_1 = p[1];
    wire p0_2 = p[2];
    wire p0_3 = p[3];

    assign gg0 = g0_3 | (p0_3 & g0_2) | (p0_3 & p0_2 & g0_1) | (p0_3 & p0_2 & p0_1 & g0_0);

    // For group1 (bits 7 downto 4)
    wire g1_4 = g[4];
    wire g1_5 = g[5];
    wire g1_6 = g[6];
    wire g1_7 = g[7];
    wire p1_5 = p[5];
    wire p1_6 = p[6];
    wire p1_7 = p[7];

    assign gg1 = g1_7 | (p1_7 & g1_6) | (p1_7 & p1_6 & g1_5) | (p1_7 & p1_6 & p1_5 & g1_4);

    // Compute carry into group1 (bit 4 carry-in), c[4], from group0 carry-out and group1 propagate
    assign c[4] = gg0 | (gp0 & c[0]);

    // Compute carries within each group by standard carry-lookahead logic:

    // Helper function: carry[i+1] = g[i] + p[i] * carry[i]
    // We'll unroll each group carry from c[0] or c[4]

    // Carries in group0 [1..4]
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    // c[4] is already assigned above (carry into bit 4)

    // Carries in group1 [5..8]
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign c[8] = g[7] | (p[7] & c[7]);  // carry out of MSB

    // Overflow detection: XOR of carry-in and carry-out of MSB bit (bit 7)
    assign overflow = c[7] ^ c[8];

endmodule