module cla_8bit(
    input  [7:0]  A,
    input  [7:0]  B,
    input         Cin,
    output [7:0]  S,
    output        Cout,
    output        P_group,  // Group Propagate
    output        G_group   // Group Generate
);
    wire [7:0] P = A ^ B; // Propagate
    wire [7:0] G = A & B; // Generate

    // Carry lookahead signals
    wire [8:0] C;
    assign C[0] = Cin;

    // Compute carries using CLA formula
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);

    // Sum bits
    assign S = P ^ C[7:0];
    assign Cout = C[8];

    // Group propagate and generate signals for hierarchical CLA
    assign P_group = &P;            // All propagates ANDed
    assign G_group = G[7] | (P[7] & G[6]) | (P[7]&P[6]&G[5]) | (P[7]&P[6]&P[5]&G[4]) |
                     (P[7]&P[6]&P[5]&P[4]&G[3]) | (P[7]&P[6]&P[5]&P[4]&P[3]&G[2]) |
                     (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&G[1]) |
                     (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&G[0]);
endmodule

// Carry-lookahead block to generate carries between 8-bit CLA blocks
module cla_4block_carrygen(
    input         Cin,
    input  [3:0]  P_group,
    input  [3:0]  G_group,
    output [4:0]  C_out // C_out[0] = Cin, C_out[4] is carry-out after block3
);
    assign C_out[0] = Cin;

    assign C_out[1] = G_group[0] | (P_group[0] & C_out[0]);
    assign C_out[2] = G_group[1] | (P_group[1] & C_out[1]);
    assign C_out[3] = G_group[2] | (P_group[2] & C_out[2]);
    assign C_out[4] = G_group[3] | (P_group[3] & C_out[3]);
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Convert 1-based indexing to 0-based internally for simplicity
    wire [7:0] A_block [3:0];
    wire [7:0] B_block [3:0];
    wire [7:0] S_block [3:0];
    wire       C_block [3:0];
    wire       P_group [3:0];
    wire       G_group [3:0];
    wire [4:0] carry_inter;

    // Split inputs into 4 blocks of 8 bits each (indexing corrected)
    assign A_block[0] = A[8:1];
    assign A_block[1] = A[16:9];
    assign A_block[2] = A[24:17];
    assign A_block[3] = A[32:25];

    assign B_block[0] = B[8:1];
    assign B_block[1] = B[16:9];
    assign B_block[2] = B[24:17];
    assign B_block[3] = B[32:25];

    // Generate carries between blocks with carry generator
    cla_4block_carrygen carrygen (
        .Cin(1'b0),
        .P_group({P_group[3],P_group[2],P_group[1],P_group[0]}),
        .G_group({G_group[3],G_group[2],G_group[1],G_group[0]}),
        .C_out(carry_inter)
    );

    // Instantiate 8-bit CLA blocks with carry_in from carry generator
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : CLA_BLOCKS
            cla_8bit cla_inst (
                .A(A_block[i]),
                .B(B_block[i]),
                .Cin(carry_inter[i]),
                .S(S_block[i]),
                .Cout(C_block[i]),
                .P_group(P_group[i]),
                .G_group(G_group[i])
            );
        end
    endgenerate

    // Output sum reconstructed with 1-based indexing
    assign S[8:1]     = S_block[0];
    assign S[16:9]    = S_block[1];
    assign S[24:17]   = S_block[2];
    assign S[32:25]   = S_block[3];

    assign C32 = C_block[3];
endmodule