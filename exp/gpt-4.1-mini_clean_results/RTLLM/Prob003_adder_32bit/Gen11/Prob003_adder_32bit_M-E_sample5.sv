module cla_8bit (
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] S,
    output       Cout,
    output       Pout,  // Block propagate: all bits propagate
    output       Gout   // Block generate: carry generated within block
);
    wire [7:0] P = A ^ B;
    wire [7:0] G = A & B;
    wire [8:0] C;

    assign C[0] = Cin;

    // Carry lookahead logic for 8 bits:
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);

    assign S = P ^ C[7:0];
    assign Cout = C[8];

    // Block propagate: all propagate bits must be 1
    assign Pout = &P;

    // Block generate: either generate in MSB or propagate and generate in lower bits
    // Gout = G[7] + (P[7] * G[6]) + (P[7]*P[6]*G[5]) + ... + (P[7]*...*P[0]*Cin)
    // Here simplified as:
    assign Gout = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) |
                  (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) |
                  (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
endmodule

// 4-bit CLA block to compute carries for each 8-bit CLA block.
// Inputs are group propagates and generates from four 8-bit blocks.
module cla_4bit_carrygen(
    input  [3:0] P,     // block propagate signals
    input  [3:0] G,     // block generate signals
    input        Cin,
    output [4:0] C_out  // carry signals C0..C4, C0=Cin, C4 carry-out of last block
);
    assign C_out[0] = Cin;
    assign C_out[1] = G[0] | (P[0] & C_out[0]);
    assign C_out[2] = G[1] | (P[1] & C_out[1]);
    assign C_out[3] = G[2] | (P[2] & C_out[2]);
    assign C_out[4] = G[3] | (P[3] & C_out[3]);
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Signals for each 8-bit CLA block
    wire [3:0] P_block;
    wire [3:0] G_block;
    wire [4:0] C_block; // Carry for blocks (C_block[0] = Cin)

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla0 (
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(C_block[0]),
        .S(S[8:1]),
        .Cout(),
        .Pout(P_block[0]),
        .Gout(G_block[0])
    );
    cla_8bit cla1 (
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(C_block[1]),
        .S(S[16:9]),
        .Cout(),
        .Pout(P_block[1]),
        .Gout(G_block[1])
    );
    cla_8bit cla2 (
        .A(A[24:17]),
        .B(B[24:17]),
        .Cin(C_block[2]),
        .S(S[24:17]),
        .Cout(),
        .Pout(P_block[2]),
        .Gout(G_block[2])
    );
    cla_8bit cla3 (
        .A(A[32:25]),
        .B(B[32:25]),
        .Cin(C_block[3]),
        .S(S[32:25]),
        .Cout(),
        .Pout(P_block[3]),
        .Gout(G_block[3])
    );

    // Instantiate the 4-bit carry lookahead generator for the 8-bit block carries
    cla_4bit_carrygen carrygen (
        .P(P_block),
        .G(G_block),
        .Cin(1'b0),
        .C_out(C_block)
    );

    assign C32 = C_block[4];
endmodule