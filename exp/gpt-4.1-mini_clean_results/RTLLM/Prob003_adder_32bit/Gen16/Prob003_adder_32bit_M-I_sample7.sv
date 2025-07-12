// 4-bit CLA block
module cla_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    output wire [3:0] S,
    output wire       Cout,
    output wire       P,  // block propagate
    output wire       G   // block generate
);
    wire [3:0] P_bit = A ^ B;
    wire [3:0] G_bit = A & B;

    wire [4:0] C;
    assign C[0] = Cin;

    // Compute carries for each bit
    assign C[1] = G_bit[0] | (P_bit[0] & C[0]);
    assign C[2] = G_bit[1] | (P_bit[1] & C[1]);
    assign C[3] = G_bit[2] | (P_bit[2] & C[2]);
    assign C[4] = G_bit[3] | (P_bit[3] & C[3]);

    assign S = P_bit ^ C[3:0];
    assign Cout = C[4];

    // Block propagate = AND of all bit propagates
    assign P = &P_bit;

    // Block generate = G3 | (P3&G2) | (P3&P2&G1) | (P3&P2&P1&G0)
    assign G = G_bit[3] |
               (P_bit[3] & G_bit[2]) |
               (P_bit[3] & P_bit[2] & G_bit[1]) |
               (P_bit[3] & P_bit[2] & P_bit[1] & G_bit[0]);
endmodule

// 16-bit CLA block using four 4-bit CLA sub-blocks
module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // block propagate
    output wire        G   // block generate
);
    // Split inputs into four 4-bit chunks
    wire [3:0] A0 = A[3:0];
    wire [3:0] A1 = A[7:4];
    wire [3:0] A2 = A[11:8];
    wire [3:0] A3 = A[15:12];

    wire [3:0] B0 = B[3:0];
    wire [3:0] B1 = B[7:4];
    wire [3:0] B2 = B[11:8];
    wire [3:0] B3 = B[15:12];

    // Outputs from 4-bit blocks
    wire [3:0] S0, S1, S2, S3;
    wire C1, C2, C3, Cout_4bit;
    wire P0, P1, P2, P3;
    wire G0, G1, G2, G3;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (.A(A0), .B(B0), .Cin(Cin),   .S(S0), .Cout(C1), .P(P0), .G(G0));
    cla_4bit cla1 (.A(A1), .B(B1), .Cin(C1),    .S(S1), .Cout(C2), .P(P1), .G(G1));
    cla_4bit cla2 (.A(A2), .B(B2), .Cin(C2),    .S(S2), .Cout(C3), .P(P2), .G(G2));
    cla_4bit cla3 (.A(A3), .B(B3), .Cin(C3),    .S(S3), .Cout(Cout_4bit), .P(P3), .G(G3));

    // Compute carries between 4-bit blocks using block generate/propagate signals
    // C1 = G0 | (P0 & Cin) computed internally in cla0
    // We already get C1, C2, C3 from cla blocks inputs, but verify consistency:

    // For completeness, compute block-level carry signals explicitly
    // (already done via cascading 4-bit CLAs with carry inputs)

    assign Cout = Cout_4bit;

    // Concatenate sum outputs
    assign S = {S3, S2, S1, S0};

    // Block propagate = P0 & P1 & P2 & P3
    assign P = P0 & P1 & P2 & P3;

    // Block generate = G3 | (P3&G2) | (P3&P2&G1) | (P3&P2&P1&G0)
    assign G = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0);
endmodule

// Top-level 32-bit CLA adder using two 16-bit CLA blocks
module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Convert 1-based inputs to zero-based internally
    wire [31:0] A_int = A[32:1];
    wire [31:0] B_int = B[32:1];

    // Split into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry-in for upper block from lower block propagate and generate
    wire Cin_high = G_low | (P_low & 1'b0); // Global carry-in is zero

    // Upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sums back to 1-based output vectors
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;
endmodule