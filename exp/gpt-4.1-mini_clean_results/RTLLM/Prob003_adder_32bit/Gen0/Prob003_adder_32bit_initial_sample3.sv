module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        PG, // Block propagate
    output        GG  // Block generate
);
    wire [16:1] P; // propagate for each bit
    wire [16:1] G; // generate for each bit
    wire [16:0] C; // carry signals, C[0] = Cin

    assign C[0] = Cin;

    // bitwise propagate and generate
    assign P = A ^ B;
    assign G = A & B;

    // Carry lookahead logic:
    // C[i] = G[i] + P[i] & C[i-1]
    assign C[1]  = G[1]  | (P[1]  & C[0]);
    assign C[2]  = G[2]  | (P[2]  & C[1]);
    assign C[3]  = G[3]  | (P[3]  & C[2]);
    assign C[4]  = G[4]  | (P[4]  & C[3]);
    assign C[5]  = G[5]  | (P[5]  & C[4]);
    assign C[6]  = G[6]  | (P[6]  & C[5]);
    assign C[7]  = G[7]  | (P[7]  & C[6]);
    assign C[8]  = G[8]  | (P[8]  & C[7]);
    assign C[9]  = G[9]  | (P[9]  & C[8]);
    assign C[10] = G[10] | (P[10] & C[9]);
    assign C[11] = G[11] | (P[11] & C[10]);
    assign C[12] = G[12] | (P[12] & C[11]);
    assign C[13] = G[13] | (P[13] & C[12]);
    assign C[14] = G[14] | (P[14] & C[13]);
    assign C[15] = G[15] | (P[15] & C[14]);
    assign C[16] = G[16] | (P[16] & C[15]);

    // Sum bits
    assign S = P ^ C[15:0];

    // Block propagate: all propagate bits must be 1
    assign PG = &P; // AND of all P bits

    // Block generate: G16 + (P16 & G15) + (P16&P15&G14) + ... 
    // For speed, compute with carry-lookahead generate:
    // GG = G16 + P16*G15 + P16*P15*G14 + ... + P16*...*P1*Cin
    // But since Cin is external, for block generate GG assume Cin=0:
    // Actually for the block generate without Cin:
    // GG = G16 + (P16 & G15) + (P16&P15 & G14) + ... + (P16 & ... & P1 & 0) 
    // last term is zero, so
    // Compute GG as carry-out when Cin=0:
    wire [16:1] carry_g;
    assign carry_g[1] = G[1];
    assign carry_g[2] = G[2]  | (P[2]  & carry_g[1]);
    assign carry_g[3] = G[3]  | (P[3]  & carry_g[2]);
    assign carry_g[4] = G[4]  | (P[4]  & carry_g[3]);
    assign carry_g[5] = G[5]  | (P[5]  & carry_g[4]);
    assign carry_g[6] = G[6]  | (P[6]  & carry_g[5]);
    assign carry_g[7] = G[7]  | (P[7]  & carry_g[6]);
    assign carry_g[8] = G[8]  | (P[8]  & carry_g[7]);
    assign carry_g[9] = G[9]  | (P[9]  & carry_g[8]);
    assign carry_g[10] = G[10] | (P[10] & carry_g[9]);
    assign carry_g[11] = G[11] | (P[11] & carry_g[10]);
    assign carry_g[12] = G[12] | (P[12] & carry_g[11]);
    assign carry_g[13] = G[13] | (P[13] & carry_g[12]);
    assign carry_g[14] = G[14] | (P[14] & carry_g[13]);
    assign carry_g[15] = G[15] | (P[15] & carry_g[14]);
    assign carry_g[16] = G[16] | (P[16] & carry_g[15]);

    assign GG = carry_g[16];

    assign Cout = C[16];
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;     // carry between lower and upper 16-bit blocks
    wire PG0, GG0; // lower 16-bit block group propagate and generate
    wire PG1, GG1; // upper 16-bit block group propagate and generate

    // Instantiate lower 16-bit CLA block (bits 1-16)
    cla_16bit CLA0(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .PG(PG0),
        .GG(GG0)
    );

    // Instantiate upper 16-bit CLA block (bits 17-32)
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

    // Compute final carry-out C32 from block propagate and generate signals
    // C32 = GG1 + PG1*C16 = GG1 + PG1*(GG0 + PG0*Cin)
    // Since Cin=0, C16 = GG0 + PG0*0 = GG0
    // So C32 = GG1 + PG1*GG0
    assign C32 = GG1 | (PG1 & GG0);
endmodule