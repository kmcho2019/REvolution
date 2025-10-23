module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,    // Group propagate
    output        G     // Group generate
);
    wire [16:1] p, g;   // propagate and generate for each bit
    wire [16:0] c;      // carry signals (c[0] = Cin)
    assign c[0] = Cin;

    genvar i;
    generate
        for(i=1; i<=16; i=i+1) begin : gen_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Carry-lookahead logic for 16 bits
    // Compute carries c[1] to c[16]
    // c[i] = g[i] | (p[i] & c[i-1])
    // To optimize, use group propagate and generate signals per block of bits
    // We'll implement full CLA equations directly for 16 bits

    wire [15:1] c_internal;

    // Level 1: c1 = g1 + p1*Cin
    assign c[1]  = g[1] | (p[1] & c[0]);
    // c2 = g2 + p2*c1
    assign c[2]  = g[2] | (p[2] & c[1]);
    assign c[3]  = g[3] | (p[3] & c[2]);
    assign c[4]  = g[4] | (p[4] & c[3]);
    assign c[5]  = g[5] | (p[5] & c[4]);
    assign c[6]  = g[6] | (p[6] & c[5]);
    assign c[7]  = g[7] | (p[7] & c[6]);
    assign c[8]  = g[8] | (p[8] & c[7]);
    assign c[9]  = g[9] | (p[9] & c[8]);
    assign c[10] = g[10]| (p[10]& c[9]);
    assign c[11] = g[11]| (p[11]& c[10]);
    assign c[12] = g[12]| (p[12]& c[11]);
    assign c[13] = g[13]| (p[13]& c[12]);
    assign c[14] = g[14]| (p[14]& c[13]);
    assign c[15] = g[15]| (p[15]& c[14]);
    assign c[16] = g[16]| (p[16]& c[15]);

    // Sum bits: S[i] = p[i] ^ c[i-1]
    generate
        for(i=1; i<=16; i=i+1) begin : gen_sum
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Group propagate: P = p1&p2&...&p16
    assign P = &p[16:1];
    // Group generate: G = g16 + p16*g15 + p16&p15*g14 + ... + p16&p15&...p2*g1
    // Implemented with carry-lookahead sum for generate signals:
    wire g1 = g[1];
    wire g2 = g[2];
    wire g3 = g[3];
    wire g4 = g[4];
    wire g5 = g[5];
    wire g6 = g[6];
    wire g7 = g[7];
    wire g8 = g[8];
    wire g9 = g[9];
    wire g10= g[10];
    wire g11= g[11];
    wire g12= g[12];
    wire g13= g[13];
    wire g14= g[14];
    wire g15= g[15];
    wire g16= g[16];

    wire p1 = p[1];
    wire p2 = p[2];
    wire p3 = p[3];
    wire p4 = p[4];
    wire p5 = p[5];
    wire p6 = p[6];
    wire p7 = p[7];
    wire p8 = p[8];
    wire p9 = p[9];
    wire p10= p[10];
    wire p11= p[11];
    wire p12= p[12];
    wire p13= p[13];
    wire p14= p[14];
    wire p15= p[15];
    wire p16= p[16];

    assign G = g16 
           | (p16 & g15)
           | (p16 & p15 & g14)
           | (p16 & p15 & p14 & g13)
           | (p16 & p15 & p14 & p13 & g12)
           | (p16 & p15 & p14 & p13 & p12 & g11)
           | (p16 & p15 & p14 & p13 & p12 & p11 & g10)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & g9)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & g8)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & g7)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & g6)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & g5)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & g4)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & g3)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & g2)
           | (p16 & p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1);

    // Carry-out
    assign Cout = c[16];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P0, G0; // lower 16-bit block propagate/generate
    wire P1, G1; // upper 16-bit block propagate/generate

    // Lower 16-bit CLA
    cla_16bit cla0 (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P0),
        .G   (G0)
    );

    // Calculate carry-in for upper 16-bit block using group generate and propagate of lower block
    // Carry in for upper block: C16 = G0 + P0 * Cin, Cin=0 here, so C16 = G0
    // However, in the top module Cin=0, so we keep C16 as from lower block Cout

    // Upper 16-bit CLA
    cla_16bit cla1 (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32),
        .P   (P1),
        .G   (G1)
    );
endmodule