module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Two's complement of B: ~B + 1 is performed by ~B with carry_in=1
    wire [63:0] B_comp = ~B;

    wire cout;
    cla_64bit_hier cla_sub (
        .A   (A),
        .B   (B_comp),
        .cin (1'b1),
        .sum (result),
        .cout(cout)
    );

    // Overflow detection as per specification
    // overflow if sign of A != sign of B and sign of result != sign of A
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire R_sign = result[63];
    assign overflow = (A_sign != B_sign) && (R_sign != A_sign);
endmodule


// Hierarchical 64-bit Carry Lookahead Adder with 16 blocks of 4 bits each
module cla_64bit_hier (
    input  wire [63:0] A,
    input  wire [63:0] B,
    input  wire        cin,
    output wire [63:0] sum,
    output wire        cout
);
    // --- Step 1: Per-bit propagate and generate ---
    wire [63:0] P = A ^ B;   // propagate
    wire [63:0] G = A & B;   // generate

    // --- Step 2: Per-4-bit block propagate and generate ---
    wire [15:0] P_block;
    wire [15:0] G_block;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : block_pg
            // indices for each 4-bit block
            wire p0 = P[i*4 + 0];
            wire p1 = P[i*4 + 1];
            wire p2 = P[i*4 + 2];
            wire p3 = P[i*4 + 3];

            wire g0 = G[i*4 + 0];
            wire g1 = G[i*4 + 1];
            wire g2 = G[i*4 + 2];
            wire g3 = G[i*4 + 3];

            // Block propagate = p3 & p2 & p1 & p0
            assign P_block[i] = p3 & p2 & p1 & p0;

            // Block generate using carry-lookahead logic:
            // G_block = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
            assign G_block[i] =
                g3 |
                (p3 & g2) |
                (p3 & p2 & g1) |
                (p3 & p2 & p1 & g0);
        end
    endgenerate

    // --- Step 3: Compute carries at block boundaries ---
    // C_block: carry into each 4-bit block, C_block[0] = cin
    wire [16:0] C_block; 
    assign C_block[0] = cin;

    // Carry into block i+1 = G_block[i] | (P_block[i] & C_block[i])
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : carry_block
            assign C_block[j+1] = G_block[j] | (P_block[j] & C_block[j]);
        end
    endgenerate

    // --- Step 4: Compute carries within each block ---
    wire [64:0] C;
    assign C[0] = cin;

    generate
        for (j = 0; j < 16; j = j + 1) begin : carry_within_block
            // carry within block bits 1 to 4
            wire c0 = C_block[j];
            wire p0 = P[j*4 + 0];
            wire g0 = G[j*4 + 0];

            wire p1 = P[j*4 + 1];
            wire g1 = G[j*4 + 1];

            wire p2 = P[j*4 + 2];
            wire g2 = G[j*4 + 2];

            wire p3 = P[j*4 + 3];
            wire g3 = G[j*4 + 3];

            // Carry equations:
            // C[i+1] = G[i] | (P[i] & C[i])

            assign C[j*4 + 1] = g0 | (p0 & c0);
            assign C[j*4 + 2] = g1 | (p1 & C[j*4 + 1]);
            assign C[j*4 + 3] = g2 | (p2 & C[j*4 + 2]);
            assign C[j*4 + 4] = g3 | (p3 & C[j*4 + 3]);
        end
    endgenerate

    assign cout = C[64];

    // --- Step 5: Compute sum ---
    assign sum = P ^ C[63:0];

endmodule