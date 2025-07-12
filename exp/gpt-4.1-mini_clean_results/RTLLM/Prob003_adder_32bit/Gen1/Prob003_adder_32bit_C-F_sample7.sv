module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        PG,     // Block propagate
    output        GG,     // Block generate
    output        Cout
);
    wire [16:1] P; // propagate per bit
    wire [16:1] G; // generate per bit
    wire [16:0] C; // carry signals, C[0]=Cin

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        // Carry generation: C[i] = G[i] + P[i] & C[i-1]
        for (i = 1; i <= 16; i = i + 1) begin : carry_chain
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[15:0];

    // Block propagate = AND of all P bits
    assign PG = &P;

    // Block generate (GG):
    // GG = G16 + P16*G15 + P16*P15*G14 + ... + P16*...*P1*Cin
    // Since Cin is external and handled outside, here we compute GG assuming Cin=0:
    // GG = carry out when Cin=0 from this block
    // So compute carry_g chain with Cin=0:
    wire [16:0] carry_g;
    assign carry_g[0] = 1'b0; // Cin=0 for group generate calculation
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_g_chain
            assign carry_g[i] = G[i] | (P[i] & carry_g[i-1]);
        end
    endgenerate
    assign GG = carry_g[16];

    // Carry out is the carry out with actual Cin
    assign Cout = C[16];

endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire PG0, GG0;
    wire PG1, GG1;
    wire Cout1;

    // Lower 16 bits CLA block (bits 1 to 16)
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .PG(PG0),
        .GG(GG0),
        .Cout(C16)
    );

    // Upper 16 bits CLA block (bits 17 to 32)
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .PG(PG1),
        .GG(GG1),
        .Cout(Cout1)
    );

    // Final carry-out:
    // C16 = GG0 + PG0*Cin (Cin=0) => C16=GG0
    // C32 = GG1 + PG1*C16
    assign C32 = GG1 | (PG1 & GG0);

endmodule