// 8-bit CLA block with group propagate and generate outputs
module cla_8bit (
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       Cout,
    output       P_group,
    output       G_group
);
    wire [8:1] P; // propagate per bit
    wire [8:1] G; // generate per bit
    wire [8:0] C; // carry signals

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;

    // Carry lookahead logic for 8 bits:
    // C[i] = G[i] + P[i]*C[i-1]
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    assign C[7] = G[7] | (P[7] & C[6]);
    assign C[8] = G[8] | (P[8] & C[7]);

    assign S = P ^ C[7:0];
    assign Cout = C[8];

    // Group propagate: all propagate bits are 1
    assign P_group = &P;
    // Group generate: G[8] + P[8]*G[7] + P[8]*P[7]*G[6] + ... + P[8]*...*P[2]*G[1]
    // This is standard CLA group generate expression for 8 bits
    wire g7 = G[7];
    wire g6 = G[6];
    wire g5 = G[5];
    wire g4 = G[4];
    wire g3 = G[3];
    wire g2 = G[2];
    wire g1 = G[1];
    wire p8 = P[8];
    wire p7 = P[7];
    wire p6 = P[6];
    wire p5 = P[5];
    wire p4 = P[4];
    wire p3 = P[3];
    wire p2 = P[2];
    wire p1 = P[1];

    assign G_group = 
        G[8] 
        | (p8 & g7)
        | (p8 & p7 & g6)
        | (p8 & p7 & p6 & g5)
        | (p8 & p7 & p6 & p5 & g4)
        | (p8 & p7 & p6 & p5 & p4 & g3)
        | (p8 & p7 & p6 & p5 & p4 & p3 & g2)
        | (p8 & p7 & p6 & p5 & p4 & p3 & p2 & g1);
endmodule


// 4-bit CLA block used at group level for carry calculation
module cla_4bit_block (
    input  [4:1] P,    // group propagate from 4 blocks
    input  [4:1] G,    // group generate from 4 blocks
    input        Cin,
    output [4:1] C,    // carry in for each block (except first which is Cin)
    output       Cout
);
    // Compute carry signals C[1] to C[4] (C[0]=Cin)
    // Use CLA logic for 4 bits
    wire C0 = Cin;

    assign C[1] = G[1] | (P[1] & C0);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    assign Cout = C[4];
endmodule


// Top-level 32-bit CLA using 4 x 8-bit CLA blocks and 1 x 4-bit CLA for carry
module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire [4:1] P_group;  // group propagate from 8-bit blocks
    wire [4:1] G_group;  // group generate from 8-bit blocks
    wire [4:1] C_blocks; // carry into each 8-bit block (except first which is 0)

    // Instantiate four 8-bit CLAs for each block
    cla_8bit cla0 (
        .A       (A[8:1]),
        .B       (B[8:1]),
        .Cin     (1'b0),
        .S       (S[8:1]),
        .Cout    (),      // unused here
        .P_group (P_group[1]),
        .G_group (G_group[1])
    );

    cla_8bit cla1 (
        .A       (A[16:9]),
        .B       (B[16:9]),
        .Cin     (C_blocks[1]),
        .S       (S[16:9]),
        .Cout    (),
        .P_group (P_group[2]),
        .G_group (G_group[2])
    );

    cla_8bit cla2 (
        .A       (A[24:17]),
        .B       (B[24:17]),
        .Cin     (C_blocks[2]),
        .S       (S[24:17]),
        .Cout    (),
        .P_group (P_group[3]),
        .G_group (G_group[3])
    );

    cla_8bit cla3 (
        .A       (A[32:25]),
        .B       (B[32:25]),
        .Cin     (C_blocks[3]),
        .S       (S[32:25]),
        .Cout    (),
        .P_group (P_group[4]),
        .G_group (G_group[4])
    );

    // 4-bit CLA for group-level carry computation
    cla_4bit_block group_carry (
        .P    (P_group),
        .G    (G_group),
        .Cin  (1'b0),
        .C    (C_blocks),
        .Cout (C32)
    );
endmodule