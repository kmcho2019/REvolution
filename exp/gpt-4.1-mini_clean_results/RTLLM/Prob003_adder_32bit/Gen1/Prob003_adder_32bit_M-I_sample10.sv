`timescale 1ns / 1ps
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       P,   // block propagate
    output       G,   // block generate
    output       Cout
);
    wire [4:1] p, g;   // propagate and generate per bit
    wire [4:0] c;      // carries, c[0] = Cin

    assign c[0] = Cin;

    assign p = A ^ B;   // propagate
    assign g = A & B;   // generate

    // Carry lookahead within 4 bits
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c[3]);

    // Sum bits
    assign S = p ^ c[3:0];

    // Block propagate: all propagates must be 1
    assign P = &p;

    // Block generate: g4 + p4*g3 + p4*p3*g2 + p4*p3*p2*g1
    assign G = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);

    assign Cout = c[4];
endmodule


module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        PG, // group propagate
    output        GG  // group generate
);
    wire [3:0] P_blk, G_blk;  // block-level propagate and generate signals
    wire [4:0] C_blk;         // carries between 4-bit blocks, C_blk[0] = Cin

    assign C_blk[0] = Cin;

    // Instantiate four 4-bit CLA blocks for bits [1..4], [5..8], [9..12], [13..16]
    cla_4bit CLA0 (.A(A[4:1]),   .B(B[4:1]),   .Cin(C_blk[0]), .S(S[4:1]),   .P(P_blk[0]), .G(G_blk[0]), .Cout());
    cla_4bit CLA1 (.A(A[8:5]),   .B(B[8:5]),   .Cin(C_blk[1]), .S(S[8:5]),   .P(P_blk[1]), .G(G_blk[1]), .Cout());
    cla_4bit CLA2 (.A(A[12:9]),  .B(B[12:9]),  .Cin(C_blk[2]), .S(S[12:9]),  .P(P_blk[2]), .G(G_blk[2]), .Cout());
    cla_4bit CLA3 (.A(A[16:13]), .B(B[16:13]), .Cin(C_blk[3]), .S(S[16:13]), .P(P_blk[3]), .G(G_blk[3]), .Cout(Cout));

    // Carry lookahead for block-level carries
    assign C_blk[1] = G_blk[0] | (P_blk[0] & C_blk[0]);
    assign C_blk[2] = G_blk[1] | (P_blk[1] & C_blk[1]);
    assign C_blk[3] = G_blk[2] | (P_blk[2] & C_blk[2]);
    assign C_blk[4] = G_blk[3] | (P_blk[3] & C_blk[3]);

    // Group propagate: all block propagates are 1
    assign PG = &P_blk;

    // Group generate: block 4 generate plus block 4 propagate & block 3 generate, etc.
    assign GG = G_blk[3]
              | (P_blk[3] & G_blk[2])
              | (P_blk[3] & P_blk[2] & G_blk[1])
              | (P_blk[3] & P_blk[2] & P_blk[1] & G_blk[0]);

endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;           // carry between lower and upper 16-bit blocks
    wire PG0, GG0;      // lower 16-bit block propagate and generate
    wire PG1, GG1;      // upper 16-bit block propagate and generate

    // Lower 16-bit CLA block (bits 1-16)
    cla_16bit CLA0(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .PG(PG0),
        .GG(GG0)
    );

    // Upper 16-bit CLA block (bits 17-32)
    wire cout_upper;
    cla_16bit CLA1(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(cout_upper),
        .PG(PG1),
        .GG(GG1)
    );

    // Compute final carry-out C32 using block-level propagate/generate signals:
    // C32 = GG1 + PG1 * C16
    // Where C16 = GG0 + PG0 * 0 (since Cin=0)
    // So, C16 = GG0
    // Therefore, C32 = GG1 + PG1 * GG0
    assign C32 = GG1 | (PG1 & GG0);
endmodule