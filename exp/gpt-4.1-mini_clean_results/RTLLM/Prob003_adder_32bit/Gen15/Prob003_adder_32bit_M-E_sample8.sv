module cla_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] S,
    output       Cout,
    output       Gout,  // Block generate
    output       Pout   // Block propagate
);
    wire [7:0] G = A & B;  // generate signals
    wire [7:0] P = A ^ B;  // propagate signals
    wire [8:0] C;

    assign C[0] = Cin;

    // Carry lookahead logic for 8 bits
    // C[i+1] = G[i] | (P[i] & C[i])
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_gen
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Block propagate = AND of all propagates
    assign Pout = &P;
    // Block generate = G7 + (P7*G6) + (P7*P6*G5) + ... + (P7*...*P0*Cin)
    // But for a block generate independent of Cin:
    // Gout = G7 + (P7*G6) + (P7*P6*G5) + ... + (P7*...*P1*G0)
    // We compute it as:
    wire g3_0 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    wire g7_4 = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    assign Gout = g7_4 | (P[7] & P[6] & P[5] & P[4] & g3_0);

    assign S = P ^ C[7:0];
    assign Cout = C[8];
endmodule

module cla_4bit_block (
    input  [3:0] G,    // generate inputs from each 8-bit block
    input  [3:0] P,    // propagate inputs from each 8-bit block
    input        Cin,
    output [4:1] C      // carries between blocks C[1] is carry into block 1, C[4] carry out of block 4
);
    // The C vector:
    // C[1] = carry into block 1
    // C[2] = carry into block 2
    // C[3] = carry into block 3
    // C[4] = carry into block 4 (carry-out of entire 32-bit adder)
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Wires for block generate and propagate
    wire [3:0] G_block;
    wire [3:0] P_block;
    wire [4:1] C_block; // carries between 8-bit blocks

    // Instantiate four 8-bit CLA blocks

    // Block 0: bits 1-8
    wire Cout0;
    cla_8bit cla0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(1'b0),
        .S(S[8:1]),
        .Cout(Cout0),
        .Gout(G_block[0]),
        .Pout(P_block[0])
    );

    // Block 1: bits 9-16
    wire Cout1;
    cla_8bit cla1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(C_block[1]),
        .S(S[16:9]),
        .Cout(Cout1),
        .Gout(G_block[1]),
        .Pout(P_block[1])
    );

    // Block 2: bits 17-24
    wire Cout2;
    cla_8bit cla2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(C_block[2]),
        .S(S[24:17]),
        .Cout(Cout2),
        .Gout(G_block[2]),
        .Pout(P_block[2])
    );

    // Block 3: bits 25-32
    wire Cout3;
    cla_8bit cla3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(C_block[3]),
        .S(S[32:25]),
        .Cout(Cout3),
        .Gout(G_block[3]),
        .Pout(P_block[3])
    );

    // Higher-level 4-bit block CLA to generate carries between blocks
    cla_4bit_block block_carry (
        .G(G_block),
        .P(P_block),
        .Cin(1'b0),
        .C(C_block)
    );

    assign C32 = C_block[4];
endmodule