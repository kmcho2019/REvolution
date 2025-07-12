// 8-bit CLA block
module cla_8bit (
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       Cout,
    output       P,    // Group propagate
    output       G     // Group generate
);
    wire [8:1] p, g;
    wire [9:0] c;

    assign c[0] = Cin;

    genvar i;
    generate
        for (i=1; i<=8; i=i+1) begin : gen_pg
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Carry calculation: c[i] = g[i] | (p[i] & c[i-1])
    generate
        for (i=1; i<=8; i=i+1) begin : gen_carry
            assign c[i] = g[i] | (p[i] & c[i-1]);
        end
    endgenerate

    // Sum bits
    generate
        for (i=1; i<=8; i=i+1) begin : gen_sum
            assign S[i] = p[i] ^ c[i-1];
        end
    endgenerate

    // Group propagate = AND of all p[i]
    assign P = &p[8:1];

    // Group generate = G8 + P8*G7 + P8*P7*G6 + ... + P8*...*P2*G1
    // Implement with propagate suffix products and OR reduction
    wire [9:1] p_suffix;
    assign p_suffix[9] = 1'b1;
    generate
        for (i=8; i>=1; i=i-1) begin : gen_psuffix
            assign p_suffix[i] = p[i] & p_suffix[i+1];
        end
    endgenerate

    wire [8:1] gen_terms;
    generate
        for (i=1; i<=8; i=i+1) begin : gen_gterms
            assign gen_terms[i] = g[i] & p_suffix[i+1];
        end
    endgenerate

    assign G = |gen_terms;

    assign Cout = c[8];
endmodule

// 4-bit CLA block for inter-block carry
module cla_4block (
    input  [3:0] P,     // Group propagate from 4 blocks
    input  [3:0] G,     // Group generate from 4 blocks
    input        Cin,
    output [4:1] C      // Carry outputs for blocks: C[1] is carry-in to block1, C[4] is carry-out
);
    // C[1] = Cin (carry into first block)
    assign C[1] = Cin;

    // Carry equations:
    // C[2] = G[1] | (P[1] & C[1])
    // C[3] = G[2] | (P[2] & C[2])
    // C[4] = G[3] | (P[3] & C[3])

    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
endmodule

// Top 32-bit adder module
module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Break 32 bits into 4 blocks of 8 bits
    wire [7:1] S0, S1, S2, S3;
    wire C0, C1, C2, C3, C4;
    wire [3:0] P, G;

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla_blk0(
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S0),
        .Cout(C0),
        .P(P[0]),
        .G(G[0])
    );

    cla_8bit cla_blk1(
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(C0),
        .S(S1),
        .Cout(C1),
        .P(P[1]),
        .G(G[1])
    );

    cla_8bit cla_blk2(
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(C1),
        .S(S2),
        .Cout(C2),
        .P(P[2]),
        .G(G[2])
    );

    cla_8bit cla_blk3(
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(C2),
        .S(S3),
        .Cout(C3),
        .P(P[3]),
        .G(G[3])
    );

    // Instead of ripple chaining carries C0->C1->C2->C3, use a 4-block CLA for carries
    wire [4:1] carry_blocks;

    cla_4block blk_carry(
        .P(P),
        .G(G),
        .Cin(1'b0),
        .C(carry_blocks)
    );

    // Overwrite block Cin with computed CLA carry for correctness
    // Block 0 carry-in is Cin=0, so carry_blocks[1] = 0

    // Recompute sums with new carry-in signals:

    cla_8bit cla_blk0_recalc(
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(carry_blocks[1]),
        .S(S0),
        .Cout(C0),
        .P(), .G()
    );

    cla_8bit cla_blk1_recalc(
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(carry_blocks[2]),
        .S(S1),
        .Cout(C1),
        .P(), .G()
    );

    cla_8bit cla_blk2_recalc(
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(carry_blocks[3]),
        .S(S2),
        .Cout(C2),
        .P(), .G()
    );

    cla_8bit cla_blk3_recalc(
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(carry_blocks[4]),
        .S(S3),
        .Cout(C3),
        .P(), .G()
    );

    assign C32 = C3;

    // Concatenate results
    assign S = {S3, S2, S1, S0};
endmodule