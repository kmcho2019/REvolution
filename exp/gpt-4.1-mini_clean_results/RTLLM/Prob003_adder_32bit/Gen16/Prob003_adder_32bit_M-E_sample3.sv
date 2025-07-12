module cla_8bit(
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       P_blk,  // Block propagate
    output       G_blk,  // Block generate
    output       Cout
);
    wire [8:1] P = A ^ B;      // propagate
    wire [8:1] G = A & B;      // generate

    wire [8:0] C;
    assign C[1] = Cin;

    // Compute carries using carry-lookahead logic
    // C[i+1] = G[i] + P[i]*C[i]
    genvar i;
    generate
        for(i=1; i<8; i=i+1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[8:1];

    // Block propagate: all P bits must be 1
    assign P_blk = &P;

    // Block generate: either last bit generate or earlier generate plus propagate chain
    assign G_blk = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]) |
                   (P[8] & P[7] & P[6] & P[5] & G[4]) | (P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) |
                   (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
                   (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]);

    assign Cout = C[9];
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Wires for block propagates and generates
    wire [4:1] P_blk, G_blk;
    wire [5:1] C_blk; // block carries: C_blk[1] = Cin = 0

    assign C_blk[1] = 1'b0; // Initial carry-in

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(C_blk[1]),
        .S(S[8:1]),
        .P_blk(P_blk[1]),
        .G_blk(G_blk[1]),
        .Cout()
    );

    cla_8bit cla1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(C_blk[2]),
        .S(S[16:9]),
        .P_blk(P_blk[2]),
        .G_blk(G_blk[2]),
        .Cout()
    );

    cla_8bit cla2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(C_blk[3]),
        .S(S[24:17]),
        .P_blk(P_blk[3]),
        .G_blk(G_blk[3]),
        .Cout()
    );

    cla_8bit cla3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(C_blk[4]),
        .S(S[32:25]),
        .P_blk(P_blk[4]),
        .G_blk(G_blk[4]),
        .Cout()
    );

    // Top-level carry-lookahead logic for 4 blocks
    // C_blk[i+1] = G_blk[i] + P_blk[i]*C_blk[i]
    assign C_blk[2] = G_blk[1] | (P_blk[1] & C_blk[1]);
    assign C_blk[3] = G_blk[2] | (P_blk[2] & C_blk[2]);
    assign C_blk[4] = G_blk[3] | (P_blk[3] & C_blk[3]);
    assign C32       = G_blk[4] | (P_blk[4] & C_blk[4]);
endmodule