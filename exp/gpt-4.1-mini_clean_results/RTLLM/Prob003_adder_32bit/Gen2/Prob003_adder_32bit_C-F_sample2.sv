module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        PG,  // Block propagate: all bits propagate
    output        GG   // Block generate: carry generate for block
);
    wire [16:1] P; // propagate signals
    wire [16:1] G; // generate signals
    wire [16:0] C; // carry signals, C[0] = Cin

    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : pg_logic
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead logic (ripple carry style within 16-bit block)
    // C[i] = G[i] | (P[i] & C[i-1])
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_logic
            assign C[i] = G[i] | (P[i] & C[i-1]);
        end
    endgenerate

    // Sum bits: S[i] = P[i] ^ C[i-1]
    generate
        for (i = 1; i <= 16; i = i + 1) begin : sum_bits
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    assign Cout = C[16];

    // Block propagate: all P bits ANDed
    assign PG = &P;

    // Block generate: recursively compute carry generate without Cin
    // GG = carry-out of block assuming Cin=0 (i.e., carry_g[16])
    wire [16:1] carry_g;
    assign carry_g[1]  = G[1];
    generate
        for (i = 2; i <= 16; i = i + 1) begin : block_generate_logic
            assign carry_g[i] = G[i] | (P[i] & carry_g[i-1]);
        end
    endgenerate

    assign GG = carry_g[16];

endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;      // Carry between lower and upper 16-bit blocks
    wire PG0, GG0; // Propagate and generate from lower 16-bit block
    wire PG1, GG1; // Propagate and generate from upper 16-bit block

    // Lower 16-bit CLA block (bits 1 to 16), Cin = 0
    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16),
        .PG  (PG0),
        .GG  (GG0)
    );

    // Upper 16-bit CLA block (bits 17 to 32), Cin = C16
    wire cout_upper;
    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(cout_upper),
        .PG  (PG1),
        .GG  (GG1)
    );

    // Final carry-out calculation:
    // C16 = GG0 + PG0 * 0 = GG0 (since Cin=0)
    // C32 = GG1 + PG1 * C16 = GG1 + PG1 * GG0
    assign C32 = GG1 | (PG1 & GG0);

endmodule