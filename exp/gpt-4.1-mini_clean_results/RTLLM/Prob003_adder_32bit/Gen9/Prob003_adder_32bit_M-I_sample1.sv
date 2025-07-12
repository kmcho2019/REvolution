// 4-bit CLA block with group propagate and generate output
module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P,   // group propagate
    output       G    // group generate
);
    wire [4:1] p, g;
    wire [4:0] c;

    assign c[0] = Cin;

    genvar i;
    generate
        for (i=1; i<=4; i=i+1) begin : gen_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead logic:
    // c1 = g1 + p1*cin
    // c2 = g2 + p2*g1 + p2*p1*cin
    // c3 = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*cin
    // c4 = g4 + p4*g3 + p4*p3*g2 + p4*p3*p2*g1 + p4*p3*p2*p1*cin (Cout)
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & c[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & c[0]);
    assign c[4] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1])
                      | (p[4] & p[3] & p[2] & p[1] & c[0]);

    // Sum bits
    generate
        for (i=1; i<=4; i=i+1) begin : gen_sum
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Group propagate: all bits propagate
    assign P = &p[4:1];

    // Group generate: G = g4 + p4*g3 + p4*p3*g2 + p4*p3*p2*g1
    assign G = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);

    assign Cout = c[4];
endmodule


// 16-bit hierarchical CLA composed of four 4-bit CLAs
module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,   // group propagate
    output        G    // group generate
);
    wire [3:0] block_P, block_G;       // Propagate and generate for each 4-bit block
    wire [4:0] c;                      // Carry signals between blocks
    assign c[0] = Cin;

    genvar blk;
    generate
        for (blk = 0; blk < 4; blk = blk + 1) begin : gen_4bit_blocks
            cla_4bit cla4 (
                .A   (A[4*blk +: 4]),    // note: [LSB +: width], but our input is [16:1]
                .B   (B[4*blk +: 4]),
                .Cin (c[blk]),
                .S   (S[4*blk +: 4]),
                .Cout(c[blk+1]),
                .P   (block_P[blk]),
                .G   (block_G[blk])
            );
        end
    endgenerate

    // The above slices A[4*blk +: 4] accesses bits [4*blk+3 : 4*blk], which counts from 0.
    // Our inputs are [16:1] indexing (MSB:LSB), so we need to carefully reindex.

    // Because inputs are [16:1], not [15:0], we can't use [start +: width] easily.
    // We'll convert slices with adjusted indexing below.

    // Reimplement the generate with correct indexing:
    // For blk=0, bits 1 to 4
    // blk=1: bits 5 to 8
    // blk=2: bits 9 to 12
    // blk=3: bits 13 to 16
endmodule

// Re-implement cla_16bit with correct indexing for [16:1]
module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,
    output        G
);
    wire [3:0] block_P, block_G;       // Propagate and generate for each 4-bit block
    wire [4:0] c;                      // Carry signals between blocks
    assign c[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla_blk0 (
        .A   (A[4:1]),
        .B   (B[4:1]),
        .Cin (c[0]),
        .S   (S[4:1]),
        .Cout(c[1]),
        .P   (block_P[0]),
        .G   (block_G[0])
    );

    cla_4bit cla_blk1 (
        .A   (A[8:5]),
        .B   (B[8:5]),
        .Cin (c[1]),
        .S   (S[8:5]),
        .Cout(c[2]),
        .P   (block_P[1]),
        .G   (block_G[1])
    );

    cla_4bit cla_blk2 (
        .A   (A[12:9]),
        .B   (B[12:9]),
        .Cin (c[2]),
        .S   (S[12:9]),
        .Cout(c[3]),
        .P   (block_P[2]),
        .G   (block_G[2])
    );

    cla_4bit cla_blk3 (
        .A   (A[16:13]),
        .B   (B[16:13]),
        .Cin (c[3]),
        .S   (S[16:13]),
        .Cout(c[4]),
        .P   (block_P[3]),
        .G   (block_G[3])
    );

    // Carry-lookahead between 4-bit blocks:
    // c[1] = G0 + P0 * c0 -- already calculated by CLA blocks internally
    // We use a CLA logic for these inter-block carries:
    // For the carry-in to block i+1 (i=0 to 2):
    // c[i+1] = block_G[i] + block_P[i] * c[i]
    // But the cla_4bit blocks have output carry c[i+1] wired accordingly, so no further assignment is needed.

    // Compute overall group propagate and generate for the 16-bit block:
    // P = P0 & P1 & P2 & P3
    assign P = &block_P;

    // G = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    assign G = block_G[3]
             | (block_P[3] & block_G[2])
             | (block_P[3] & block_P[2] & block_G[1])
             | (block_P[3] & block_P[2] & block_P[1] & block_G[0]);

    assign Cout = c[4];
endmodule


// Top-level 32-bit adder composed of two 16-bit hierarchical CLAs
module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P0, G0;
    wire P1, G1;

    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .P   (P0),
        .G   (G0)
    );

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