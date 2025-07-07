module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P; // Propagate signals
    wire [16:1] G; // Generate signals
    wire [16:0] C; // Carry signals, C[0] = Cin

    assign C[0] = Cin;

    // Generate propagate and generate signals
    genvar i;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : pg_gen
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Carry lookahead logic
    // C[i] = G[i] | (P[i] & C[i-1])
    // We can expand carries to avoid ripple:
    // C[1] = G[1] | (P[1] & C[0])
    // C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0])
    // ...
    // To implement this efficiently, we use hierarchical CLA logic.

    // First level group propagate and generate signals for 4-bit groups
    wire [4:1] PG; // Group propagate
    wire [4:1] GG; // Group generate

    // Group 1: bits 1-4
    assign PG[1] = P[4] & P[3] & P[2] & P[1];
    assign GG[1] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);

    // Group 2: bits 5-8
    assign PG[2] = P[8] & P[7] & P[6] & P[5];
    assign GG[2] = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]);

    // Group 3: bits 9-12
    assign PG[3] = P[12] & P[11] & P[10] & P[9];
    assign GG[3] = G[12] | (P[12] & G[11]) | (P[12] & P[11] & G[10]) | (P[12] & P[11] & P[10] & G[9]);

    // Group 4: bits 13-16
    assign PG[4] = P[16] & P[15] & P[14] & P[13];
    assign GG[4] = G[16] | (P[16] & G[15]) | (P[16] & P[15] & G[14]) | (P[16] & P[15] & P[14] & G[13]);

    // Calculate carries at group boundaries
    wire [4:0] Cg; // group carries
    assign Cg[0] = Cin;
    assign Cg[1] = GG[1] | (PG[1] & Cg[0]);
    assign Cg[2] = GG[2] | (PG[2] & Cg[1]);
    assign Cg[3] = GG[3] | (PG[3] & Cg[2]);
    assign Cg[4] = GG[4] | (PG[4] & Cg[3]);

    // Calculate carries inside each group
    // For bits 1-4
    assign C[1] = G[1] | (P[1] & Cg[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & Cg[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & Cg[0]);
    assign C[4] = GG[1] | (PG[1] & Cg[0]);

    // For bits 5-8
    assign C[5] = G[5] | (P[5] & Cg[1]);
    assign C[6] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & Cg[1]);
    assign C[7] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & Cg[1]);
    assign C[8] = GG[2] | (PG[2] & Cg[1]);

    // For bits 9-12
    assign C[9]  = G[9]  | (P[9]  & Cg[2]);
    assign C[10] = G[10] | (P[10] & G[9])  | (P[10] & P[9]  & Cg[2]);
    assign C[11] = G[11] | (P[11] & G[10]) | (P[11] & P[10] & G[9])  | (P[11] & P[10] & P[9]  & Cg[2]);
    assign C[12] = GG[3] | (PG[3] & Cg[2]);

    // For bits 13-16
    assign C[13] = G[13] | (P[13] & Cg[3]);
    assign C[14] = G[14] | (P[14] & G[13]) | (P[14] & P[13] & Cg[3]);
    assign C[15] = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & Cg[3]);
    assign C[16] = GG[4] | (PG[4] & Cg[3]);

    // Sum bits
    generate
        for (i = 1; i <= 16; i = i + 1) begin : sum_gen
            assign S[i] = P[i] ^ C[i-1];
        end
    endgenerate

    assign Cout = C[16];
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Lower 16 bits
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    // Upper 16 bits
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule