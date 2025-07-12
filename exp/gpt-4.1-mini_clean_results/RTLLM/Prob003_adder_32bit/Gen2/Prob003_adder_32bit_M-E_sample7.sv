module cla_8bit(
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       Cout,
    output       Gblk,  // Block generate
    output       Pblk   // Block propagate
);
    wire [8:1] G; // generate per bit
    wire [8:1] P; // propagate per bit
    wire [8:0] C; // carries

    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    // Compute carries using CLA logic for 8 bits
    // C[i+1] = G[i] + P[i]*C[i]
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

    // Block propagate: all propagates ANDed
    assign Pblk = &P;
    // Block generate: generate occurs if block produces carry-out ignoring carry-in:
    // Gblk = G8 + P8*G7 + P8*P7*G6 + ... + P8*...*P2*G1
    // This is the carry-out from block if Cin=0.

    wire g1_2 = G[2] | (P[2] & G[1]);
    wire g1_3 = G[3] | (P[3] & g1_2);
    wire g1_4 = G[4] | (P[4] & g1_3);
    wire g1_5 = G[5] | (P[5] & g1_4);
    wire g1_6 = G[6] | (P[6] & g1_5);
    wire g1_7 = G[7] | (P[7] & g1_6);
    assign Gblk = G[8] | (P[8] & g1_7);

endmodule

module cla_4bit_block(
    input  [4:1] Gblk, // block generates from 8-bit blocks
    input  [4:1] Pblk, // block propagates from 8-bit blocks
    input        Cin,
    output [4:1] C    // carry-ins to blocks
);
    // C[1] = carry-in to block 1 = Cin (input)
    // C[i+1] = Gblk[i] + Pblk[i]*C[i]

    assign C[1] = Cin;
    assign C[2] = Gblk[1] | (Pblk[1] & C[1]);
    assign C[3] = Gblk[2] | (Pblk[2] & C[2]);
    assign C[4] = Gblk[3] | (Pblk[3] & C[3]);
    // Note: C[4] is carry-in to block 4, carry-out is computed inside 8-bit block

endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire [4:1] Gblk, Pblk;       // block generate/propagate from 8-bit blocks
    wire [4:1] Cblk;             // carry-in to each 8-bit block
    wire [8:1] sum_blocks [4:1]; // sums from each block
    wire [4:1] Cout_block;       // carry-out from each 8-bit block (unused except last)
    
    // Instantiate 4 8-bit CLA blocks
    cla_8bit cla0 (.A(A[8:1]),    .B(B[8:1]),    .Cin(1'b0),   .S(sum_blocks[1]), .Cout(Cout_block[1]), .Gblk(Gblk[1]), .Pblk(Pblk[1]));
    cla_8bit cla1 (.A(A[16:9]),   .B(B[16:9]),   .Cin(Cblk[1]), .S(sum_blocks[2]), .Cout(Cout_block[2]), .Gblk(Gblk[2]), .Pblk(Pblk[2]));
    cla_8bit cla2 (.A(A[24:17]),  .B(B[24:17]),  .Cin(Cblk[2]), .S(sum_blocks[3]), .Cout(Cout_block[3]), .Gblk(Gblk[3]), .Pblk(Pblk[3]));
    cla_8bit cla3 (.A(A[32:25]),  .B(B[32:25]),  .Cin(Cblk[3]), .S(sum_blocks[4]), .Cout(Cout_block[4]), .Gblk(Gblk[4]), .Pblk(Pblk[4]));

    // Compute carry-ins to blocks using 4-bit block CLA
    cla_4bit_block blk_cla (
        .Gblk(Gblk),
        .Pblk(Pblk),
        .Cin(1'b0),
        .C(Cblk)
    );

    // Assign outputs
    assign S[8:1]    = sum_blocks[1];
    assign S[16:9]   = sum_blocks[2];
    assign S[24:17]  = sum_blocks[3];
    assign S[32:25]  = sum_blocks[4];
    assign C32 = Cout_block[4];

endmodule