module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] p;   // propagate signals per bit
    wire [16:1] g;   // generate signals per bit

    // Group propagate and generate signals for each 4-bit block
    wire [4:1] P;    // group propagate
    wire [4:1] G;    // group generate

    // Carry signals at group boundaries: C[0], C[4], C[8], C[12], C[16]
    wire [16:0] C;

    assign C[0] = Cin;

    genvar i;

    // Calculate bit-level generate and propagate
    generate
        for (i = 1; i <= 16; i = i +1) begin : pg_bit
            assign p[i] = A[i] ^ B[i];
            assign g[i] = A[i] & B[i];
        end
    endgenerate

    // Calculate group generate and propagate for each 4-bit group
    // Group k covers bits [(4k-3) to 4k]
    // P[k] = p4 & p3 & p2 & p1 (all propagate)
    // G[k] = g4 | (p4 & g3) | (p4 & p3 & g2) | (p4 & p3 & p2 & g1)
    generate
        for (i = 1; i <= 4; i = i + 1) begin : grp_pg
            wire p4, p3, p2, p1;
            wire g4, g3, g2, g1;
            assign p1 = p[4*(i-1)+1];
            assign p2 = p[4*(i-1)+2];
            assign p3 = p[4*(i-1)+3];
            assign p4 = p[4*(i-1)+4];

            assign g1 = g[4*(i-1)+1];
            assign g2 = g[4*(i-1)+2];
            assign g3 = g[4*(i-1)+3];
            assign g4 = g[4*(i-1)+4];

            assign P[i] = p1 & p2 & p3 & p4;
            assign G[i] = g4 | (p4 & g3) | (p4 & p3 & g2) | (p4 & p3 & p2 & g1);
        end
    endgenerate

    // Compute carries at group boundaries using group G and P signals:
    // C[4]  = G1 + P1*Cin
    // C[8]  = G2 + P2*C[4]
    // C[12] = G3 + P3*C[8]
    // C[16] = G4 + P4*C[12]
    assign C[4]  = G[1] | (P[1] & C[0]);
    assign C[8]  = G[2] | (P[2] & C[4]);
    assign C[12] = G[3] | (P[3] & C[8]);
    assign C[16] = G[4] | (P[4] & C[12]);

    // Compute internal carries within each 4-bit group
    // For each bit inside group k: C[i] = g[i] | (p[i] & C[i-1])
    generate
        for (i = 1; i <= 16; i = i + 1) begin : carry_bit
            if ((i % 4) != 1) begin
                assign C[i] = g[i] | (p[i] & C[i-1]);
            end
            // else carry already assigned for group boundary bits (C[4], C[8], ...)
            // We have assigned those above with group G/P logic
        end
    endgenerate

    // Compute sum bits
    generate
        for (i = 1; i <= 16; i = i +1) begin : sum_bit
            assign S[i] = p[i] ^ C[i-1];
        end
    endgenerate

    assign Cout = C[16];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );

endmodule