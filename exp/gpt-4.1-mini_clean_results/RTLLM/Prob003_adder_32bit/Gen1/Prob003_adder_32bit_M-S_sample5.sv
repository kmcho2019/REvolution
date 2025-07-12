module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        PG, // Block propagate
    output        GG  // Block generate
);
    wire [16:1] P, G;
    wire [16:0] C;

    assign C[0] = Cin;
    assign P = A ^ B;   // propagate
    assign G = A & B;   // generate

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_generate
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Block propagate is AND of all propagates
    assign PG = &P;

    // Block generate computed by carry chain with Cin=0
    // Using generate block to compute GG = carry out with Cin=0
    wire [16:0] carry_g;
    assign carry_g[0] = 1'b0;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : block_generate_calc
            assign carry_g[i] = G[i] | (P[i] & carry_g[i-1]);
        end
    endgenerate
    assign GG = carry_g[16];
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire PG0, GG0;
    wire PG1, GG1;

    cla_16bit CLA0(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .PG(PG0),
        .GG(GG0)
    );

    cla_16bit CLA1(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(), // Not used explicitly here
        .PG(PG1),
        .GG(GG1)
    );

    // Final carry out: C32 = GG1 + PG1*C16
    assign C32 = GG1 | (PG1 & C16);
endmodule