module cla_8bit (
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       Cout,
    output       G_block,  // Group generate for block
    output       P_block   // Group propagate for block
);
    wire [8:1] G; // generate per bit
    wire [8:1] P; // propagate per bit
    wire [8:0] C; // carries

    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    // Carry lookahead for 8 bits (fast carry generation)
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[5] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[6] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[7] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[8] = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]) | (P[8] & P[7] & P[6] & P[5] & G[4]) | (P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);

    assign S = P ^ C[7:0];

    assign Cout = C[8];

    // Group generate and propagate signals for this block
    assign G_block = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]) | (P[8] & P[7] & P[6] & P[5] & G[4]) | (P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]);
    assign P_block = &P;  // AND of all propagate bits
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Internal wires for carries between 8-bit blocks
    wire C0 = 1'b0; // initial carry-in is zero
    wire C8, C16, C24, C32;

    // Group generate and propagate for each 8-bit block
    wire G0, P0, G1, P1, G2, P2, G3, P3;

    // Instantiate four 8-bit CLA blocks
    cla_8bit cla0 (
        .A       (A[8:1]),
        .B       (B[8:1]),
        .Cin     (C0),
        .S       (S[8:1]),
        .Cout    (C8),
        .G_block (G0),
        .P_block (P0)
    );

    cla_8bit cla1 (
        .A       (A[16:9]),
        .B       (B[16:9]),
        .Cin     (C8),
        .S       (S[16:9]),
        .Cout    (C16),
        .G_block (G1),
        .P_block (P1)
    );

    cla_8bit cla2 (
        .A       (A[24:17]),
        .B       (B[24:17]),
        .Cin     (C16),
        .S       (S[24:17]),
        .Cout    (C24),
        .G_block (G2),
        .P_block (P2)
    );

    cla_8bit cla3 (
        .A       (A[32:25]),
        .B       (B[32:25]),
        .Cin     (C24),
        .S       (S[32:25]),
        .Cout    (C32),
        .G_block (G3),
        .P_block (P3)
    );

    // Carry lookahead logic for block carries: compute C8, C16, C24 in parallel from G and P signals
    // Using CLA equations for 4 blocks:

    // Recompute C8, C16, C24 from G/P to ensure proper parallel CLA logic (override direct Cout wiring)
    wire C4_0 = C0;
    // Carry to block 1
    wire C4_1 = G0 | (P0 & C4_0);
    // Carry to block 2
    wire C4_2 = G1 | (P1 & G0) | (P1 & P0 & C4_0);
    // Carry to block 3
    wire C4_3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & C4_0);
    // Carry to block 4 (final carry out)
    wire C4_4 = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & C4_0);

    // Override block CIN signals with carry-lookahead results for correctness and timing consistency
    // (In above cla_* instantiations, we connected Cin signals directly from Cout of previous block.
    // Instead, we use carry-lookahead block carries to drive internal CLAs by regiving these signals.)

    // To implement this cleanly, we need to separate the CLA blocks into pure 8-bit adders (with Cin input),
    // and in top-level logic wire the carry inputs properly.

    // Redefine with wire arrays and separate assignment for clarity:

endmodule