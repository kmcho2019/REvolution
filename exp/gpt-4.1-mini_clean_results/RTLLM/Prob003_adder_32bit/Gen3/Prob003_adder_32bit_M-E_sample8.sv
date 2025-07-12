module cla_8bit(
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       G_block,
    output       P_block
);
    wire [8:1] G; // generate signals for each bit
    wire [8:1] P; // propagate signals for each bit
    wire [9:0] C; // carry signals (C[0] = Cin, C[8] = carry out)
    
    assign G = A & B;
    assign P = A ^ B;

    assign C[0] = Cin;

    // 8-bit carry-lookahead logic using parallel prefix (carry chain)
    // carry[i+1] = G[i] + P[i]*carry[i]

    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    assign C[7] = G[7] | (P[7] & C[6]);
    assign C[8] = G[8] | (P[8] & C[7]);

    // Sum calculation
    assign S = P ^ C[7:0];

    // Block propagate and generate signals:
    // P_block = P[1] & P[2] & ... & P[8]
    // G_block = G[8] + P[8]*G[7] + P[8]*P[7]*G[6] + ... + P[8]*...*P[2]*G[1]
    assign P_block = &P; // AND of all propagates

    // Generate block generate signal using carry-lookahead expansion
    wire g1p = G[7] & P[8];
    wire g2p = G[6] & P[7] & P[8];
    wire g3p = G[5] & P[6] & P[7] & P[8];
    wire g4p = G[4] & P[5] & P[6] & P[7] & P[8];
    wire g5p = G[3] & P[4] & P[5] & P[6] & P[7] & P[8];
    wire g6p = G[2] & P[3] & P[4] & P[5] & P[6] & P[7] & P[8];
    wire g7p = G[1] & P[2] & P[3] & P[4] & P[5] & P[6] & P[7] & P[8];

    assign G_block = G[8] | g1p | g2p | g3p | g4p | g5p | g6p | g7p;

endmodule

module cla_4block_carry_gen(
    input         Cin,
    input  [3:0]  P_block,
    input  [3:0]  G_block,
    output [3:1]  C_block
);
    // Compute carry-in to blocks 2,3,4 (C_block[1], C_block[2], C_block[3])
    // C1 = G0 + P0*Cin
    // C2 = G1 + P1*G0 + P1*P0*Cin
    // C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin

    wire p0p1 = P_block[0] & P_block[1];
    wire p0p1p2 = p0p1 & P_block[2];

    assign C_block[1] = G_block[0] | (P_block[0] & Cin);
    assign C_block[2] = G_block[1] | (P_block[1] & G_block[0]) | (p0p1 & Cin);
    assign C_block[3] = G_block[2] | (P_block[2] & G_block[1]) | (P_block[2] & P_block[1] & G_block[0]) | (p0p1p2 & Cin);

endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire [3:0] G_block;  // block generate signals
    wire [3:0] P_block;  // block propagate signals
    wire [3:1] C_block;  // carry-in for blocks 2,3,4
    wire C0 = 1'b0;      // input carry to the entire adder

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(C0),
        .S(S[8:1]),
        .G_block(G_block[0]),
        .P_block(P_block[0])
    );

    cla_8bit cla1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(C_block[1]),
        .S(S[16:9]),
        .G_block(G_block[1]),
        .P_block(P_block[1])
    );

    cla_8bit cla2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(C_block[2]),
        .S(S[24:17]),
        .G_block(G_block[2]),
        .P_block(P_block[2])
    );

    cla_8bit cla3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(C_block[3]),
        .S(S[32:25]),
        .G_block(G_block[3]),
        .P_block(P_block[3])
    );

    // Generate carry-ins for blocks 1 to 3 (cla1, cla2, cla3)
    cla_4block_carry_gen carry_gen (
        .Cin(C0),
        .P_block(P_block),
        .G_block(G_block),
        .C_block(C_block)
    );

    // Carry out of the entire 32-bit adder = carry out of last 8-bit CLA block
    // Calculate it using the last block generate and propagate plus its carry-in
    assign C32 = G_block[3] | (P_block[3] & C_block[3]);

endmodule