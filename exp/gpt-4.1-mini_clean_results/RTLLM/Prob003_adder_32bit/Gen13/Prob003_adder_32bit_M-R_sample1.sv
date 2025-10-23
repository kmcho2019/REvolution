module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    // Per-bit propagate and generate
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Group propagate and generate for 4-bit blocks
    wire [3:0] P_group;
    wire [3:0] G_group;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg
            // Propagate of 4-bit block: AND of propagates
            assign P_group[i] = &P[i*4 +: 4];
            // Generate of 4-bit block:
            // G[block] = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
            wire g0 = G[i*4 + 0];
            wire g1 = G[i*4 + 1];
            wire g2 = G[i*4 + 2];
            wire g3 = G[i*4 + 3];
            wire p0 = P[i*4 + 0];
            wire p1 = P[i*4 + 1];
            wire p2 = P[i*4 + 2];
            assign G_group[i] = g3 | (p2 & g2) | (p2 & p1 & g1) | (p2 & p1 & p0 & g0);
        end
    endgenerate

    // Carry signals into each 4-bit block
    wire [4:0] C_block;
    assign C_block[0] = Cin;
    assign C_block[1] = G_group[0] | (P_group[0] & C_block[0]);
    assign C_block[2] = G_group[1] | (P_group[1] & C_block[1]);
    assign C_block[3] = G_group[2] | (P_group[2] & C_block[2]);
    assign C_block[4] = G_group[3] | (P_group[3] & C_block[3]);

    // Compute carry signals within each 4-bit block
    wire [15:0] C; // carry into each bit (C[0] unused, C[1] is carry into bit 0, etc.)
    // For each 4-bit block:
    generate
        for (i = 0; i < 4; i = i + 1) begin : block_carries
            wire c_in = C_block[i];
            wire p0 = P[i*4 + 0];
            wire p1 = P[i*4 + 1];
            wire p2 = P[i*4 + 2];
            wire g0 = G[i*4 + 0];
            wire g1 = G[i*4 + 1];
            wire g2 = G[i*4 + 2];

            // Carry into bit 0 of this block is c_in
            assign C[i*4 + 0] = c_in;
            // Carry into bit 1 = G0 + P0*C0
            assign C[i*4 + 1] = g0 | (p0 & c_in);
            // Carry into bit 2 = G1 + P1*G0 + P1*P0*C0
            assign C[i*4 + 2] = g1 | (p1 & g0) | (p1 & p0 & c_in);
            // Carry into bit 3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*C0
            assign C[i*4 + 3] = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & c_in);
        end
    endgenerate

    // Sum bits: S = P ^ carry_in
    // carry_in for bit i is C[i]
    assign S = P ^ C[15:0];

    // Carry out is carry out of last bit
    assign Cout = C_block[4];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs from [32:1] to [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map sum outputs back to [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule