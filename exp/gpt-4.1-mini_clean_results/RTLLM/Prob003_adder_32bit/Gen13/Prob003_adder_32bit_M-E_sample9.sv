module cla_8bit (
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       Cout,
    output       P_blk, // Block propagate
    output       G_blk  // Block generate
);
    wire [8:1] P; // bit propagate
    wire [8:1] G; // bit generate
    wire [8:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry lookahead within 8 bits
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[5] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[6] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[7] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[8] = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]) | (P[8] & P[7] & P[6] & P[5] & G[4]) | (P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);

    assign S = P ^ C[7:0];
    assign Cout = C[8];

    // Block propagate: all bits propagate
    assign P_blk = &P;
    // Block generate: any bit generates a carry that propagates through all previous bits
    assign G_blk = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]) | (P[8] & P[7] & P[6] & P[5] & G[4]) | (P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]);
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Wires for block propagate and generate signals
    wire [4:1] P_blk;
    wire [4:1] G_blk;
    wire [4:0] C_blk; // Carry signals between blocks, C_blk[0] = 0

    assign C_blk[0] = 1'b0; // Initial carry-in

    // Compute block carries using carry lookahead for blocks
    // Carry lookahead for 4 blocks:
    // C_blk[1] = G_blk[1] | (P_blk[1] & C_blk[0]);
    // C_blk[2] = G_blk[2] | (P_blk[2] & G_blk[1]) | (P_blk[2] & P_blk[1] & C_blk[0]);
    // C_blk[3] = G_blk[3] | (P_blk[3] & G_blk[2]) | (P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[3] & P_blk[2] & P_blk[1] & C_blk[0]);
    // C_blk[4] = G_blk[4] | (P_blk[4] & G_blk[3]) | (P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & C_blk[0]);

    assign C_blk[1] = G_blk[1] | (P_blk[1] & C_blk[0]);
    assign C_blk[2] = G_blk[2] | (P_blk[2] & G_blk[1]) | (P_blk[2] & P_blk[1] & C_blk[0]);
    assign C_blk[3] = G_blk[3] | (P_blk[3] & G_blk[2]) | (P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[3] & P_blk[2] & P_blk[1] & C_blk[0]);
    assign C_blk[4] = G_blk[4] | (P_blk[4] & G_blk[3]) | (P_blk[4] & P_blk[3] & G_blk[2]) | (P_blk[4] & P_blk[3] & P_blk[2] & G_blk[1]) | (P_blk[4] & P_blk[3] & P_blk[2] & P_blk[1] & C_blk[0]);

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(C_blk[0]),
        .S(S[8:1]),
        .Cout(),
        .P_blk(P_blk[1]),
        .G_blk(G_blk[1])
    );

    cla_8bit cla1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(C_blk[1]),
        .S(S[16:9]),
        .Cout(),
        .P_blk(P_blk[2]),
        .G_blk(G_blk[2])
    );

    cla_8bit cla2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(C_blk[2]),
        .S(S[24:17]),
        .Cout(),
        .P_blk(P_blk[3]),
        .G_blk(G_blk[3])
    );

    cla_8bit cla3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(C_blk[3]),
        .S(S[32:25]),
        .Cout(C32),
        .P_blk(P_blk[4]),
        .G_blk(G_blk[4])
    );
endmodule