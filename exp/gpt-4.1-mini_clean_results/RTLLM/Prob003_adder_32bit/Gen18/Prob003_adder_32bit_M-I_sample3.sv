module cla_4bit(
    input  [3:0] G,   // generate signals for 4 bits
    input  [3:0] P,   // propagate signals for 4 bits
    input        Cin,
    output [4:0] C    // carry signals (C[0]=Cin, C[4]=Cout)
);
    // Carry equations:
    // C[1] = G[0] + P[0]*C[0]
    // C[2] = G[1] + P[1]*G[0] + P[1]*P[0]*C[0]
    // C[3] = G[2] + P[2]*G[1] + P[2]*P[1]*G[0] + P[2]*P[1]*P[0]*C[0]
    // C[4] = G[3] + P[3]*G[2] + P[3]*P[2]*G[1] + P[3]*P[2]*P[1]*G[0] + P[3]*P[2]*P[1]*P[0]*C[0]

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] G; // bit generate
    wire [15:0] P; // bit propagate
    wire [4:0] C_block; // carry between 4-bit blocks (5 carry values for 4 blocks)
    wire [3:0] G_block; // generate for each 4-bit block
    wire [3:0] P_block; // propagate for each 4-bit block
    wire [16:0] C_bits; // carry signals for each bit (C_bits[0]=Cin, C_bits[16]=Cout)
    assign C_bits[0] = Cin;

    // Generate and propagate for each bit
    assign G = A & B;
    assign P = A ^ B;

    genvar i;

    // Generate block-level G_block and P_block for 4 blocks (4 bits each)
    generate
        for (i=0; i<4; i=i+1) begin : block_gp
            // bits in the block i*4 to i*4+3
            // G_block[i] = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
            // P_block[i] = P3 & P2 & P1 & P0
            wire [3:0] g = G[i*4 +:4];
            wire [3:0] p = P[i*4 +:4];

            assign G_block[i] =
                g[3] |
                (p[3] & g[2]) |
                (p[3] & p[2] & g[1]) |
                (p[3] & p[2] & p[1] & g[0]);
            assign P_block[i] = p[3] & p[2] & p[1] & p[0];
        end
    endgenerate

    // Compute carries between 4-bit blocks using 4-bit CLA
    cla_4bit block_cla (
        .G(G_block),
        .P(P_block),
        .Cin(Cin),
        .C(C_block)
    );

    // Now compute carry for each bit inside each 4-bit block
    generate
        for (i=0; i<4; i=i+1) begin : bit_carry
            wire c_in_block = C_block[i];
            wire [3:0] g = G[i*4 +:4];
            wire [3:0] p = P[i*4 +:4];
            wire [4:0] c_local;

            // carry for bits inside this block using the same formula as cla_4bit
            cla_4bit bit_cla (
                .G(g),
                .P(p),
                .Cin(c_in_block),
                .C(c_local)
            );

            assign C_bits[i*4 + 1 +:4] = c_local[1:4];
        end
    endgenerate

    // Sum calculation
    assign S = P ^ C_bits[15:0];

    assign Cout = C_bits[16];
endmodule

module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit cla_lower (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule