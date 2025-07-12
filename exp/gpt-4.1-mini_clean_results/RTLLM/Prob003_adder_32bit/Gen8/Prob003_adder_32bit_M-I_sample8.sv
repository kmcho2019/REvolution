module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P_block,
    output       G_block
);
    wire [4:1] P; // propagate bits
    wire [4:1] G; // generate bits
    wire [4:0] C; // carries

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Compute carries inside 4-bit block with carry-lookahead logic
    // Carries:
    // C1 = G0 + P0*C0, indexing from 1 so G1, P1, C0, etc.
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) 
                    | (P[4] & P[3] & P[2] & P[1] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Block propagate and generate
    assign P_block = &P; // all propagates must be 1 to propagate
    assign G_block = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) 
                     | (P[4] & P[3] & P[2] & G[1]);
endmodule


module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [3:0] P_block;
    wire [3:0] G_block;
    wire [4:0] C_block; // carry signals between 4-bit blocks

    assign C_block[0] = Cin;

    // Instantiate 4 blocks of 4-bit CLA
    cla_4bit cla_block0 (
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(C_block[0]),
        .S(S[4:1]),
        .Cout(),
        .P_block(P_block[0]),
        .G_block(G_block[0])
    );

    cla_4bit cla_block1 (
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(C_block[1]),
        .S(S[8:5]),
        .Cout(),
        .P_block(P_block[1]),
        .G_block(G_block[1])
    );

    cla_4bit cla_block2 (
        .A(A[12:9]),
        .B(B[12:9]),
        .Cin(C_block[2]),
        .S(S[12:9]),
        .Cout(),
        .P_block(P_block[2]),
        .G_block(G_block[2])
    );

    cla_4bit cla_block3 (
        .A(A[16:13]),
        .B(B[16:13]),
        .Cin(C_block[3]),
        .S(S[16:13]),
        .Cout(),
        .P_block(P_block[3]),
        .G_block(G_block[3])
    );

    // Carry lookahead logic for the 4-bit block carries
    // C1 = G0 + P0*C0
    assign C_block[1] = G_block[0] | (P_block[0] & C_block[0]);
    assign C_block[2] = G_block[1] | (P_block[1] & G_block[0]) | (P_block[1] & P_block[0] & C_block[0]);
    assign C_block[3] = G_block[2] | (P_block[2] & G_block[1]) | (P_block[2] & P_block[1] & G_block[0])
                      | (P_block[2] & P_block[1] & P_block[0] & C_block[0]);
    assign C_block[4] = G_block[3] | (P_block[3] & G_block[2]) | (P_block[3] & P_block[2] & G_block[1])
                      | (P_block[3] & P_block[2] & P_block[1] & G_block[0])
                      | (P_block[3] & P_block[2] & P_block[1] & P_block[0] & C_block[0]);

    assign Cout = C_block[4];
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Lower 16-bit CLA
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    // Upper 16-bit CLA
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule