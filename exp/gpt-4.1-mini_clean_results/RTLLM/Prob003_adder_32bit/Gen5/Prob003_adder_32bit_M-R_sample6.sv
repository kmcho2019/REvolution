module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] G; // Generate signals
    wire [15:0] P; // Propagate signals
    wire [16:0] C; // Carry signals

    // Generate and Propagate signals
    assign G = A & B;
    assign P = A ^ B;

    // Carry[0] = Cin
    assign C[0] = Cin;

    // Group generate and propagate for 4-bit groups
    wire [3:0] GG; // group generate
    wire [3:0] GP; // group propagate

    // Compute group generate and propagate for each 4-bit block
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_prop_block
            // Group generate for bits i*4+3 downto i*4
            // GG[i] = G3 + (P3*G2) + (P3*P2*G1) + (P3*P2*P1*G0)
            wire g3 = G[i*4+3];
            wire g2 = G[i*4+2];
            wire g1 = G[i*4+1];
            wire g0 = G[i*4+0];
            wire p3 = P[i*4+3];
            wire p2 = P[i*4+2];
            wire p1 = P[i*4+1];
            wire p0 = P[i*4+0];

            assign GG[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
            assign GP[i] = p3 & p2 & p1 & p0;
        end
    endgenerate

    // Carry into each 4-bit block using group generate/propagate signals
    wire [4:0] C_block;

    assign C_block[0] = Cin;
    assign C_block[1] = GG[0] | (GP[0] & C_block[0]);
    assign C_block[2] = GG[1] | (GP[1] & C_block[1]);
    assign C_block[3] = GG[2] | (GP[2] & C_block[2]);
    assign C_block[4] = GG[3] | (GP[3] & C_block[3]);

    // Now compute carries inside each 4-bit block in parallel
    // C for each bit: C[i+1] = G[i] + P[i]*C[i]
    // For bits 0..3 in block 0:
    assign C[0] = Cin;

    // Block 0 (bits 0-3)
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);

    // Block 1 (bits 4-7)
    assign C[5] = G[4] | (P[4] & C_block[1]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);

    // Block 2 (bits 8-11)
    assign C[9]  = G[8]  | (P[8]  & C_block[2]);
    assign C[10] = G[9]  | (P[9]  & C[9]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G[11] | (P[11] & C[11]);

    // Block 3 (bits 12-15)
    assign C[13] = G[12] | (P[12] & C_block[3]);
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & C[14]);
    assign C[16] = G[15] | (P[15] & C[15]);

    // Sum bits
    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule

module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule