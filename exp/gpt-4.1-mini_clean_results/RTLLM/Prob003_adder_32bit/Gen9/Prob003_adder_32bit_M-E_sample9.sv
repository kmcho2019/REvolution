module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       G, // block generate
    output       P, // block propagate
    output       Cout
);
    wire [4:1] p, g;
    wire [4:0] c;

    assign c[0] = Cin;

    // Propagate and generate per bit
    assign p = A ^ B;
    assign g = A & B;

    // Carry lookahead logic
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & c[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & c[0]);
    assign c[4] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & c[0]);

    // Sum bits
    assign S = p ^ c[3:0];

    // Block generate and propagate
    assign G = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);
    assign P = p[4] & p[3] & p[2] & p[1];

    assign Cout = c[4];
endmodule

module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [3:0] blockG, blockP;
    wire [4:0] c; // carries into each 4-bit block

    assign c[0] = Cin;

    // Instantiate 4 blocks of 4-bit CLA
    cla_4bit cla0 (
        .A   (A[4:1]),
        .B   (B[4:1]),
        .Cin (c[0]),
        .S   (S[4:1]),
        .G   (blockG[0]),
        .P   (blockP[0]),
        .Cout()
    );
    cla_4bit cla1 (
        .A   (A[8:5]),
        .B   (B[8:5]),
        .Cin (c[1]),
        .S   (S[8:5]),
        .G   (blockG[1]),
        .P   (blockP[1]),
        .Cout()
    );
    cla_4bit cla2 (
        .A   (A[12:9]),
        .B   (B[12:9]),
        .Cin (c[2]),
        .S   (S[12:9]),
        .G   (blockG[2]),
        .P   (blockP[2]),
        .Cout()
    );
    cla_4bit cla3 (
        .A   (A[16:13]),
        .B   (B[16:13]),
        .Cin (c[3]),
        .S   (S[16:13]),
        .G   (blockG[3]),
        .P   (blockP[3]),
        .Cout()
    );

    // Calculate carries into each 4-bit block using CLA equations
    assign c[1] = blockG[0] | (blockP[0] & c[0]);
    assign c[2] = blockG[1] | (blockP[1] & blockG[0]) | (blockP[1] & blockP[0] & c[0]);
    assign c[3] = blockG[2] | (blockP[2] & blockG[1]) | (blockP[2] & blockP[1] & blockG[0]) | (blockP[2] & blockP[1] & blockP[0] & c[0]);
    assign c[4] = blockG[3] | (blockP[3] & blockG[2]) | (blockP[3] & blockP[2] & blockG[1]) | (blockP[3] & blockP[2] & blockP[1] & blockG[0]) | (blockP[3] & blockP[2] & blockP[1] & blockP[0] & c[0]);

    assign Cout = c[4];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire G0, P0, G1, P1;
    wire c1;

    // Lower 16-bit CLA
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    // To implement true carry lookahead between the 16-bit blocks, compute group generate/propagate of lower and upper blocks

    // Compute group generate and propagate of lower 16-bit block
    // Reuse 4-bit block outputs from cla_16bit is complicated; instead, reimplement group signals here

    // Extract propagate and generate per bit for lower 16 bits
    wire [16:1] p_low = A[16:1] ^ B[16:1];
    wire [16:1] g_low = A[16:1] & B[16:1];
    wire P_low, G_low;
    assign P_low = &p_low; // All propagate for lower 16 bits
    // Group generate for lower 16 bits using carry-lookahead formula
    // Use the standard CLA formula for group generate:
    assign G_low =
      g_low[16] |
      (p_low[16] & g_low[15]) |
      (p_low[16] & p_low[15] & g_low[14]) |
      (p_low[16] & p_low[15] & p_low[14] & g_low[13]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & g_low[12]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & g_low[11]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & g_low[10]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & g_low[9]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & g_low[8]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & p_low[8] & g_low[7]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & p_low[8] & p_low[7] & g_low[6]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & p_low[8] & p_low[7] & p_low[6] & g_low[5]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & p_low[8] & p_low[7] & p_low[6] & p_low[5] & g_low[4]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & p_low[8] & p_low[7] & p_low[6] & p_low[5] & p_low[4] & g_low[3]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & p_low[8] & p_low[7] & p_low[6] & p_low[5] & p_low[4] & p_low[3] & g_low[2]) |
      (p_low[16] & p_low[15] & p_low[14] & p_low[13] & p_low[12] & p_low[11] & p_low[10] & p_low[9] & p_low[8] & p_low[7] & p_low[6] & p_low[5] & p_low[4] & p_low[3] & p_low[2] & g_low[1]);

    // Similarly for upper 16 bits
    wire [16:1] p_high = A[32:17] ^ B[32:17];
    wire [16:1] g_high = A[32:17] & B[32:17];
    wire P_high, G_high;
    assign P_high = &p_high;
    assign G_high =
      g_high[16] |
      (p_high[16] & g_high[15]) |
      (p_high[16] & p_high[15] & g_high[14]) |
      (p_high[16] & p_high[15] & p_high[14] & g_high[13]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & g_high[12]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & g_high[11]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & g_high[10]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & g_high[9]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & g_high[8]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & p_high[8] & g_high[7]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & p_high[8] & p_high[7] & g_high[6]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & p_high[8] & p_high[7] & p_high[6] & g_high[5]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & p_high[8] & p_high[7] & p_high[6] & p_high[5] & g_high[4]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & p_high[8] & p_high[7] & p_high[6] & p_high[5] & p_high[4] & g_high[3]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & p_high[8] & p_high[7] & p_high[6] & p_high[5] & p_high[4] & p_high[3] & g_high[2]) |
      (p_high[16] & p_high[15] & p_high[14] & p_high[13] & p_high[12] & p_high[11] & p_high[10] & p_high[9] & p_high[8] & p_high[7] & p_high[6] & p_high[5] & p_high[4] & p_high[3] & p_high[2] & g_high[1]);

    // Compute carry-in for upper 16 bits by carry-lookahead formula
    assign c1 = G_low | (P_low & 1'b0); // initial carry-in zero for entire 32-bit adder

    // Actually, carry-in to upper 16-bit block is C16 from cla_low, which is equivalent to c1 above
    // So use C16 directly to feed upper block

    // Upper 16-bit CLA instance
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule