module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,    // Group propagate of 16 bits
    output        G     // Group generate of 16 bits
);
    wire [16:1] p, g;
    // 4-bit group generate and propagate
    wire [4:1] P_grp, G_grp;

    // Generate propagate and generate for each bit
    assign p = A ^ B;
    assign g = A & B;

    // Compute 4-bit group propagate and generate signals
    // For bits i*4 down to (i-1)*4+1
    // P_grp[i] = AND of p bits in the group
    // G_grp[i] = g_msb + p_msb*g_msb-1 + ... recursively for the 4 bits
    // We'll explicitly assign each:

    // Group 1: bits 1 to 4
    assign P_grp[1] = p[4] & p[3] & p[2] & p[1];
    assign G_grp[1] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);

    // Group 2: bits 5 to 8
    assign P_grp[2] = p[8] & p[7] & p[6] & p[5];
    assign G_grp[2] = g[8] | (p[8] & g[7]) | (p[8] & p[7] & g[6]) | (p[8] & p[7] & p[6] & g[5]);

    // Group 3: bits 9 to 12
    assign P_grp[3] = p[12] & p[11] & p[10] & p[9];
    assign G_grp[3] = g[12] | (p[12] & g[11]) | (p[12] & p[11] & g[10]) | (p[12] & p[11] & p[10] & g[9]);

    // Group 4: bits 13 to 16
    assign P_grp[4] = p[16] & p[15] & p[14] & p[13];
    assign G_grp[4] = g[16] | (p[16] & g[15]) | (p[16] & p[15] & g[14]) | (p[16] & p[15] & p[14] & g[13]);

    // Compute carries into each 4-bit group
    wire c0, c1, c2, c3, c4;
    assign c0 = Cin;
    assign c1 = G_grp[1] | (P_grp[1] & c0);
    assign c2 = G_grp[2] | (P_grp[2] & c1);
    assign c3 = G_grp[3] | (P_grp[3] & c2);
    assign c4 = G_grp[4] | (P_grp[4] & c3);
    assign Cout = c4;

    // Now compute internal carries inside each 4-bit group based on carries into groups
    wire [16:0] c;  // Carry for bits 0 to 16, c[0] = Cin
    assign c[0] = Cin;

    // Helper task: for each bit, c[i] = g[i] | (p[i] & c[i-1])
    // We'll unroll explicitly grouped by 4 bits

    // Group 1: bits 1-4
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c[3]);

    // Group 2: bits 5-8
    assign c[5] = g[5] | (p[5] & c[4]);
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = g[7] | (p[7] & c[6]);
    assign c[8] = g[8] | (p[8] & c[7]);

    // Group 3: bits 9-12
    assign c[9]  = g[9]  | (p[9]  & c[8]);
    assign c[10] = g[10] | (p[10] & c[9]);
    assign c[11] = g[11] | (p[11] & c[10]);
    assign c[12] = g[12] | (p[12] & c[11]);

    // Group 4: bits 13-16
    assign c[13] = g[13] | (p[13] & c[12]);
    assign c[14] = g[14] | (p[14] & c[13]);
    assign c[15] = g[15] | (p[15] & c[14]);
    assign c[16] = g[16] | (p[16] & c[15]);

    // Sum bits
    assign S = p ^ c[15:0];

    // Group propagate and generate for full 16 bits
    assign P = &p[16:1];
    // G can be computed hierarchically using groups and carry-in
    // G = G_grp[4] | (P_grp[4] & G_grp[3]) | (P_grp[4] & P_grp[3] & G_grp[2]) | (P_grp[4] & P_grp[3] & P_grp[2] & G_grp[1])
    assign G = G_grp[4] | (P_grp[4] & G_grp[3]) | (P_grp[4] & P_grp[3] & G_grp[2]) | (P_grp[4] & P_grp[3] & P_grp[2] & G_grp[1]);
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P0, G0;
    wire P1, G1;

    // Lower 16 bits CLA
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P0),
        .G   (G0)
    );

    // Upper 16 bits CLA: carry-in is C16 from lower block
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P1),
        .G   (G1)
    );
endmodule