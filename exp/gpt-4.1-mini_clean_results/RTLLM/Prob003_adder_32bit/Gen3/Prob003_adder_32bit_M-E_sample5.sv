module cla_8bit(
    input  [7:0]  A,
    input  [7:0]  B,
    input         Cin,
    output [7:0]  S,
    output        Cout,
    output        P_blk,
    output        G_blk
);
    // Propagate and Generate signals for each bit
    wire [7:0] P = A ^ B;     // propagate
    wire [7:0] G = A & B;     // generate

    // Carry signals: C[0] = Cin, C[8] = Cout
    wire [8:0] C;
    assign C[0] = Cin;

    // Calculate carries using CLA logic:
    // C[i+1] = G[i] + P[i]*C[i]
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);

    // Sum calculation
    assign S = P ^ C[7:0];

    // Block propagate: P_blk = P0 & P1 & ... & P7
    assign P_blk = &P;

    // Block generate: G_blk = G7 | (P7 & G6) | (P7 & P6 & G5) | ... + (P7 & P6 & ... & P0 & Cin)
    // Use parallel prefix structure for G_blk:
    wire g0_p0 = G[0];
    wire g1_p1 = G[1] | (P[1] & G[0]);
    wire g2_p2 = G[2] | (P[2] & g1_p1);
    wire g3_p3 = G[3] | (P[3] & g2_p2);
    wire g4_p4 = G[4] | (P[4] & g3_p3);
    wire g5_p5 = G[5] | (P[5] & g4_p4);
    wire g6_p6 = G[6] | (P[6] & g5_p5);
    wire g7_p7 = G[7] | (P[7] & g6_p6);
    assign G_blk = g7_p7;

    assign Cout = C[8];
endmodule

module cla_4bit(
    input  [3:0] P,
    input  [3:0] G,
    input        Cin,
    output [3:0] C,    // carry-in to each block (C[0] = carry into block 0 = Cin)
    output       Cout
);
    // Calculate carries for each group using CLA logic:
    // C[0] = Cin (carry in to first block)
    // C[1] = G[0] + P[0]*Cin
    // C[2] = G[1] + P[1]*C[1]
    // C[3] = G[2] + P[2]*C[2]
    // Cout = G[3] + P[3]*C[3]

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Remap input indexing to zero-based internally for convenience
    wire [31:0] A0 = {A[32],A[31],A[30],A[29],A[28],A[27],A[26],A[25],
                      A[24],A[23],A[22],A[21],A[20],A[19],A[18],A[17],
                      A[16],A[15],A[14],A[13],A[12],A[11],A[10],A[9],
                      A[8],A[7],A[6],A[5],A[4],A[3],A[2],A[1]};
    wire [31:0] B0 = {B[32],B[31],B[30],B[29],B[28],B[27],B[26],B[25],
                      B[24],B[23],B[22],B[21],B[20],B[19],B[18],B[17],
                      B[16],B[15],B[14],B[13],B[12],B[11],B[10],B[9],
                      B[8],B[7],B[6],B[5],B[4],B[3],B[2],B[1]};

    // Split into four 8-bit chunks for cla_8bit blocks
    wire [7:0] A_blocks [3:0];
    wire [7:0] B_blocks [3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : block_assign
            assign A_blocks[i] = A0[8*(3 - i) +: 8]; // big endian mapping: block0 is MSB (bits 31..24)
            assign B_blocks[i] = B0[8*(3 - i) +: 8];
        end
    endgenerate

    // Outputs from 8-bit CLA blocks
    wire [7:0] S_blocks [3:0];
    wire       Cout_blocks [3:0];
    wire       P_blocks [3:0];
    wire       G_blocks [3:0];

    // Instantiate 8-bit CLAs, carry-ins to be assigned after 4-bit CLA
    wire [3:0] carry_in_blocks;

    genvar j;
    generate
        for (j=0; j<4; j=j+1) begin : cla8_blocks
            cla_8bit cla8 (
                .A(A_blocks[j]),
                .B(B_blocks[j]),
                .Cin(carry_in_blocks[j]),
                .S(S_blocks[j]),
                .Cout(Cout_blocks[j]),
                .P_blk(P_blocks[j]),
                .G_blk(G_blocks[j])
            );
        end
    endgenerate

    // Top level 4-bit CLA to generate carry_in_blocks for each 8-bit block
    // carry_in_blocks[0] = 0 (initial carry-in)
    // carry_in_blocks[1..3] computed by cla_4bit block from P_blocks, G_blocks

    wire carry_out_top;

    cla_4bit cla4(
        .P(P_blocks),
        .G(G_blocks),
        .Cin(1'b0),
        .C(carry_in_blocks),
        .Cout(carry_out_top)
    );

    assign C32 = carry_out_top;

    // Assemble sum outputs back to 1-based indexing S[32:1]
    // Concatenate from MSB block (block 0) to LSB block (block 3)
    wire [31:0] sum_comb;
    assign sum_comb = {S_blocks[0], S_blocks[1], S_blocks[2], S_blocks[3]};
    generate
        for (i=0; i<32; i=i+1) begin : sum_assign
            assign S[32 - i] = sum_comb[i];
        end
    endgenerate
endmodule