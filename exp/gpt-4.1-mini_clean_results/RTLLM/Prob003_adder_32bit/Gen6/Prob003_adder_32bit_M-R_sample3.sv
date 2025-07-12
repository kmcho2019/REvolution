module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P;   // Propagate signals (bitwise)
    wire [16:1] G;   // Generate signals (bitwise)
    
    // Group propagate and generate signals for 4 groups of 4 bits
    wire [4:1] GP;   // Group propagate signals
    wire [4:1] GG;   // Group generate signals
    
    // Carry signals: C[0] = Cin, C[1..16] are carries into bits 1..16
    wire [16:0] C;
    assign C[0] = Cin;

    genvar i;
    // Compute bitwise propagate and generate
    generate
        for (i = 1; i <= 16; i = i + 1) begin : pg_bits
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Compute group propagate and generate for each 4-bit block
    // Group j covers bits [4j:4j-3], i.e. group 1: bits 1-4, group 2: bits 5-8, etc.
    generate
        for (i = 1; i <= 4; i = i + 1) begin : grp_pg
            wire p0 = P[(4*i)-3];
            wire p1 = P[(4*i)-2];
            wire p2 = P[(4*i)-1];
            wire p3 = P[4*i];

            wire g0 = G[(4*i)-3];
            wire g1 = G[(4*i)-2];
            wire g2 = G[(4*i)-1];
            wire g3 = G[4*i];

            // Group propagate: all propagate in group
            assign GP[i] = p3 & p2 & p1 & p0;

            // Group generate: generate or propagate chain inside group
            assign GG[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Compute carries into each group (C[4], C[8], C[12], C[16])
    // Using group generate and propagate signals and Cin
    wire [4:1] C_grp;
    // Carry into group 1 (bit 4)
    assign C_grp[1] = GG[1] | (GP[1] & C[0]);
    // Carry into group 2 (bit 8)
    assign C_grp[2] = GG[2] | (GP[2] & C_grp[1]);
    // Carry into group 3 (bit 12)
    assign C_grp[3] = GG[3] | (GP[3] & C_grp[2]);
    // Carry into group 4 (bit 16)
    assign C_grp[4] = GG[4] | (GP[4] & C_grp[3]);

    // Now resolve carries inside each 4-bit group using bitwise P,G and group carry-in
    // For group 1 bits 1-4:
    assign C[4] = C_grp[1];
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // For group 2 bits 5-8:
    assign C[8] = C_grp[2];
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    assign C[7] = G[7] | (P[7] & C[6]);

    // For group 3 bits 9-12:
    assign C[12] = C_grp[3];
    assign C[9] = G[9] | (P[9] & C[8]);
    assign C[10] = G[10] | (P[10] & C[9]);
    assign C[11] = G[11] | (P[11] & C[10]);

    // For group 4 bits 13-16:
    assign C[16] = C_grp[4];
    assign C[13] = G[13] | (P[13] & C[12]);
    assign C[14] = G[14] | (P[14] & C[13]);
    assign C[15] = G[15] | (P[15] & C[14]);

    // Compute sum bits
    generate
        for (i = 1; i <= 16; i = i + 1) begin : sum_bits
            assign S[i] = P[i] ^ C[i-1];
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

    // Instantiate lower 16-bit CLA block
    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    // Instantiate upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule