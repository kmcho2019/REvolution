module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    // Per-bit propagate and generate
    wire [15:0] p = A ^ B;
    wire [15:0] g = A & B;

    // Intermediate prefix signals for carry calculation
    // Define combined generate and propagate pairs: (G,P)
    // prefix step: G_kj = G_k + P_k * G_j; P_kj = P_k * P_j;
    // We compute carry as c[i+1] = G[i:0] + P[i:0]*Cin using prefix combines.

    // Stage 1: combine pairs of bits
    wire [7:0] G1, P1;
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin
            assign G1[i] = g[2*i+1] | (p[2*i+1] & g[2*i]);
            assign P1[i] = p[2*i+1] & p[2*i];
        end
    endgenerate

    // Stage 2: combine pairs of stage 1
    wire [3:0] G2, P2;
    generate
        for (i=0; i<4; i=i+1) begin
            assign G2[i] = G1[2*i+1] | (P1[2*i+1] & G1[2*i]);
            assign P2[i] = P1[2*i+1] & P1[2*i];
        end
    endgenerate

    // Stage 3
    wire [1:0] G3, P3;
    generate
        for (i=0; i<2; i=i+1) begin
            assign G3[i] = G2[2*i+1] | (P2[2*i+1] & G2[2*i]);
            assign P3[i] = P2[2*i+1] & P2[2*i];
        end
    endgenerate

    // Stage 4
    wire G4, P4;
    assign G4 = G3[1] | (P3[1] & G3[0]);
    assign P4 = P3[1] & P3[0];

    // Compute carry-in for each bit
    wire c0 = Cin;
    wire c1  = g[0] | (p[0] & c0);
    wire c2  = g[1] | (p[1] & c1);
    wire c3  = g[2] | (p[2] & c2);
    wire c4  = g[3] | (p[3] & c3);
    wire c5  = g[4] | (p[4] & c4);
    wire c6  = g[5] | (p[5] & c5);
    wire c7  = g[6] | (p[6] & c6);
    wire c8  = g[7] | (p[7] & c7);
    wire c9  = g[8] | (p[8] & c8);
    wire c10 = g[9] | (p[9] & c9);
    wire c11 = g[10] | (p[10] & c10);
    wire c12 = g[11] | (p[11] & c11);
    wire c13 = g[12] | (p[12] & c12);
    wire c14 = g[13] | (p[13] & c13);
    wire c15 = g[14] | (p[14] & c14);
    wire c16 = g[15] | (p[15] & c15);

    // Alternatively, to keep hierarchical prefix logic, can compute carries in groups, but here we just assign them linearly for simplicity.
    // Final carries vector
    wire [16:0] c = {c16, c15, c14, c13, c12, c11, c10, c9, c8, c7, c6, c5, c4, c3, c2, c1, c0};

    assign S = p ^ c[15:0];
    assign Cout = c16;

    // Block propagate and generate for the 16-bit block
    assign P = &p;
    assign G = G4 | (P4 & Cin);

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);

    // Internally convert to zero-based indexing for easier slicing
    wire [31:0] A_int = {A[32], A[31], A[30], A[29], A[28], A[27], A[26], A[25],
                         A[24], A[23], A[22], A[21], A[20], A[19], A[18], A[17],
                         A[16], A[15], A[14], A[13], A[12], A[11], A[10], A[9],
                         A[8],  A[7],  A[6],  A[5],  A[4],  A[3],  A[2],  A[1]};
    wire [31:0] B_int = {B[32], B[31], B[30], B[29], B[28], B[27], B[26], B[25],
                         B[24], B[23], B[22], B[21], B[20], B[19], B[18], B[17],
                         B[16], B[15], B[14], B[13], B[12], B[11], B[10], B[9],
                         B[8],  B[7],  B[6],  B[5],  B[4],  B[3],  B[2],  B[1]};

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry into high block using block generate and propagate
    // Cin_high = G_low + P_low * 0 = G_low
    wire Cin_high = G_low;

    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Output concatenation with bit rearrangement from zero-based internal to [32:1] output
    genvar idx;
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : SUM_LOW_ASSIGN
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : SUM_HIGH_ASSIGN
            assign S[idx+17] = S_high[idx];
        end
    endgenerate

endmodule