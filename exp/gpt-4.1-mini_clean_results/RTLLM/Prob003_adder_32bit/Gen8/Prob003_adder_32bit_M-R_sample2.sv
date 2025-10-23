module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P, // Block propagate
    output wire        G  // Block generate
);
    wire [15:0] P_internal; // propagate bits
    wire [15:0] G_internal; // generate bits
    wire [16:0] C;          // carry signals

    assign P_internal = A ^ B;
    assign G_internal = A & B;
    assign C[0] = Cin;

    // Explicit carry computation without generate loop:
    // C[i+1] = G[i] | (P[i] & C[i])
    assign C[1]  = G_internal[0]  | (P_internal[0]  & C[0]);
    assign C[2]  = G_internal[1]  | (P_internal[1]  & C[1]);
    assign C[3]  = G_internal[2]  | (P_internal[2]  & C[2]);
    assign C[4]  = G_internal[3]  | (P_internal[3]  & C[3]);
    assign C[5]  = G_internal[4]  | (P_internal[4]  & C[4]);
    assign C[6]  = G_internal[5]  | (P_internal[5]  & C[5]);
    assign C[7]  = G_internal[6]  | (P_internal[6]  & C[6]);
    assign C[8]  = G_internal[7]  | (P_internal[7]  & C[7]);
    assign C[9]  = G_internal[8]  | (P_internal[8]  & C[8]);
    assign C[10] = G_internal[9]  | (P_internal[9]  & C[9]);
    assign C[11] = G_internal[10] | (P_internal[10] & C[10]);
    assign C[12] = G_internal[11] | (P_internal[11] & C[11]);
    assign C[13] = G_internal[12] | (P_internal[12] & C[12]);
    assign C[14] = G_internal[13] | (P_internal[13] & C[13]);
    assign C[15] = G_internal[14] | (P_internal[14] & C[14]);
    assign C[16] = G_internal[15] | (P_internal[15] & C[15]);

    assign S = P_internal ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: all bits propagate
    assign P = &P_internal;

    // Block generate: computed as G = G15 + P15*G14 + ... + P15*...*P0*Cin
    // Compute prefix generate via explicit assign:
    wire g0 = G_internal[0];
    wire g1 = G_internal[1];
    wire g2 = G_internal[2];
    wire g3 = G_internal[3];
    wire g4 = G_internal[4];
    wire g5 = G_internal[5];
    wire g6 = G_internal[6];
    wire g7 = G_internal[7];
    wire g8 = G_internal[8];
    wire g9 = G_internal[9];
    wire g10 = G_internal[10];
    wire g11 = G_internal[11];
    wire g12 = G_internal[12];
    wire g13 = G_internal[13];
    wire g14 = G_internal[14];
    wire g15 = G_internal[15];

    wire p0 = P_internal[0];
    wire p1 = P_internal[1];
    wire p2 = P_internal[2];
    wire p3 = P_internal[3];
    wire p4 = P_internal[4];
    wire p5 = P_internal[5];
    wire p6 = P_internal[6];
    wire p7 = P_internal[7];
    wire p8 = P_internal[8];
    wire p9 = P_internal[9];
    wire p10 = P_internal[10];
    wire p11 = P_internal[11];
    wire p12 = P_internal[12];
    wire p13 = P_internal[13];
    wire p14 = P_internal[14];
    wire p15 = P_internal[15];

    wire g0_1  = g1  | (p1  & g0);
    wire g0_2  = g2  | (p2  & g0_1);
    wire g0_3  = g3  | (p3  & g0_2);
    wire g0_4  = g4  | (p4  & g0_3);
    wire g0_5  = g5  | (p5  & g0_4);
    wire g0_6  = g6  | (p6  & g0_5);
    wire g0_7  = g7  | (p7  & g0_6);
    wire g0_8  = g8  | (p8  & g0_7);
    wire g0_9  = g9  | (p9  & g0_8);
    wire g0_10 = g10 | (p10 & g0_9);
    wire g0_11 = g11 | (p11 & g0_10);
    wire g0_12 = g12 | (p12 & g0_11);
    wire g0_13 = g13 | (p13 & g0_12);
    wire g0_14 = g14 | (p14 & g0_13);
    wire g0_15 = g15 | (p15 & g0_14);

    // Final block generate depends on Cin=0 for external block usage; in general, it's the full chain
    assign G = g0_15 | (p15 & p14 & p13 & p12 & p11 & p10 & p9 & p8 & p7 & p6 & p5 & p4 & p3 & p2 & p1 & p0 & Cin);

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based vectors
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar i;
    generate
        for (i = 0; i < 32; i = i +1) begin : input_map_loop
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA block, carry-in 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry into upper block is carry-out from lower block
    wire Cin_high = C16;

    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map outputs back to [32:1]
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_low_map_loop
            assign S[i+1] = S_low[i];
        end
        for (i = 0; i < 16; i = i + 1) begin : sum_high_map_loop
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule