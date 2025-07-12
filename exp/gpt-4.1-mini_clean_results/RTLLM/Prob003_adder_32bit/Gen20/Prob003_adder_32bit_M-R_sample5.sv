module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P, G;
    wire [16:0] C;

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Group propagate and generate signals for 4-bit blocks
    wire [4:1] GP, GG;

    genvar i;
    generate
        for (i = 1; i <= 4; i = i + 1) begin : block_pg
            // Each 4-bit block: bits [4i:4i-3]
            // block propagate = AND of 4 P bits
            assign GP[i] = P[4*i] & P[4*i-1] & P[4*i-2] & P[4*i-3];
            // block generate = G[msb] OR (P[msb] AND G[msb-1]) OR ... cascading down
            assign GG[i] =
                G[4*i] |
                (P[4*i] & G[4*i-1]) |
                (P[4*i] & P[4*i-1] & G[4*i-2]) |
                (P[4*i] & P[4*i-1] & P[4*i-2] & G[4*i-3]);
        end
    endgenerate

    // Calculate carries into each 4-bit block
    wire [4:0] C_block;
    assign C_block[0] = Cin;
    assign C_block[1] = GG[1] | (GP[1] & C_block[0]);
    assign C_block[2] = GG[2] | (GP[2] & C_block[1]);
    assign C_block[3] = GG[3] | (GP[3] & C_block[2]);
    assign C_block[4] = GG[4] | (GP[4] & C_block[3]);

    // Calculate carry within each 4-bit block
    // For each block:
    // C[4i -3] = C_block[i-1]
    // Then compute other internal carries similarly using G and P signals

    // Helper function to compute internal carries in 4-bit blocks
    // We unroll these manually for each block

    // Block 1 bits 1 to 4
    assign C[1] = C_block[0];
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[1]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[1]);

    // Block 2 bits 5 to 8
    assign C[5] = C_block[1];
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & C[5]);
    assign C[8] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & C[5]);

    // Block 3 bits 9 to 12
    assign C[9]  = C_block[2];
    assign C[10] = G[9]  | (P[9]  & C[9]);
    assign C[11] = G[10] | (P[10] & G[9]) | (P[10] & P[9] & C[9]);
    assign C[12] = G[11] | (P[11] & G[10]) | (P[11] & P[10] & G[9]) | (P[11] & P[10] & P[9] & C[9]);

    // Block 4 bits 13 to 16
    assign C[13] = C_block[3];
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & G[13]) | (P[14] & P[13] & C[13]);
    assign C[16] = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & C[13]);

    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit lower_half (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit upper_half (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule