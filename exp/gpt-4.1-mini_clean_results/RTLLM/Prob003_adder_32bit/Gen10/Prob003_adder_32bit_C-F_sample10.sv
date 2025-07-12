// 4-bit CLA block: Computes sum and carry for 4 bits, outputs group propagate and generate
module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P_group,  // Group propagate
    output wire       G_group   // Group generate
);
    wire [3:0] P, G;    // Propagate and generate per bit
    wire [4:0] C;       // Carries

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry signals computed in parallel (carry-lookahead)
    // C[1] = G[0] + P[0]*C[0]
    // C[2] = G[1] + P[1]*G[0] + P[1]*P[0]*C[0]
    // C[3] = G[2] + P[2]*G[1] + P[2]*P[1]*G[0] + P[2]*P[1]*P[0]*C[0]
    // C[4] = G[3] + P[3]*G[2] + P[3]*P[2]*G[1] + P[3]*P[2]*P[1]*G[0] + P[3]*P[2]*P[1]*P[0]*C[0]

    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0])
                            | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group propagate and generate signals for 4-bit block
    assign P_group = &P; // all propagates ANDed
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

// 16-bit CLA block composed of four 4-bit CLA blocks with hierarchical carry lookahead
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Instantiate four 4-bit CLAs
    wire [3:0] S0, S1, S2, S3;
    wire C0, C1, C2, C3, C4;
    wire P0, P1, P2, P3;
    wire G0, G1, G2, G3;

    assign C0 = Cin;

    // 4-bit CLA blocks
    cla_4bit cla0 (.A(A[3:0]),   .B(B[3:0]),   .Cin(C0),   .S(S0), .Cout(C1), .P_group(P0), .G_group(G0));
    cla_4bit cla1 (.A(A[7:4]),   .B(B[7:4]),   .Cin(C1),   .S(S1), .Cout(C2), .P_group(P1), .G_group(G1));
    cla_4bit cla2 (.A(A[11:8]),  .B(B[11:8]),  .Cin(C2),   .S(S2), .Cout(C3), .P_group(P2), .G_group(G2));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C3),   .S(S3), .Cout(C4), .P_group(P3), .G_group(G3));

    // Compute carries between 4-bit blocks using group signals with carry-lookahead
    // C1 = G0 + P0*Cin
    // C2 = G1 + P1*G0 + P1*P0*Cin
    // C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    // C4 = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*Cin

    assign C1 = G0 | (P0 & C0);
    assign C2 = G1 | (P1 & G0) | (P1 & P0 & C0);
    assign C3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & C0);
    assign C4 = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & C0);

    assign S = {S3, S2, S1, S0};
    assign Cout = C4;
endmodule

// Top-level 32-bit adder instantiating two optimized 16-bit CLA blocks
module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs from [32:1] to [31:0] zero-based internally
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit cla_low (
        .A   (A_low),
        .B   (B_low),
        .Cin (1'b0),
        .S   (S_low),
        .Cout(C16)
    );

    // Upper 16-bit CLA block, carry-in = carry-out from lower block
    cla_16bit cla_high (
        .A   (A_high),
        .B   (B_high),
        .Cin (C16),
        .S   (S_high),
        .Cout(C32)
    );

    // Map outputs back from zero-based to [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule