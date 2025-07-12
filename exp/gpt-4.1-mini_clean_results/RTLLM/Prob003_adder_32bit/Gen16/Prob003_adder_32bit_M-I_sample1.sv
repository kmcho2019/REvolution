module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    wire [15:0] P; // propagate signals for each bit
    wire [15:0] G; // generate signals for each bit
    wire [3:0]  GP; // group propagate signals for each 4-bit group
    wire [3:0]  GG; // group generate signals for each 4-bit group
    wire [4:0]  C;  // carry signals: C[0] = Cin, C[4] = Cout

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Compute group propagate (GP) and generate (GG) for 4 groups of 4 bits:
    // Group i: bits [4*i + 3 : 4*i]
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : grp_p_g
            wire p0 = P[4*i + 0];
            wire p1 = P[4*i + 1];
            wire p2 = P[4*i + 2];
            wire p3 = P[4*i + 3];
            wire g0 = G[4*i + 0];
            wire g1 = G[4*i + 1];
            wire g2 = G[4*i + 2];
            wire g3 = G[4*i + 3];
            // group propagate: all propagate bits ANDed
            assign GP[i] = p3 & p2 & p1 & p0;
            // group generate: G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
            assign GG[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Compute carry-in for each group using GP and GG and the carry-in C[0]
    // Carry into group i+1 = GG[i] + GP[i]*carry_in_to_group_i
    assign C[1] = GG[0] | (GP[0] & C[0]);
    assign C[2] = GG[1] | (GP[1] & C[1]);
    assign C[3] = GG[2] | (GP[2] & C[2]);
    assign C[4] = GG[3] | (GP[3] & C[3]);
    assign Cout = C[4];

    // Within each group, compute internal carries for bits 1,2,3
    // Each carry[i+1] = G[i] + P[i]*carry[i]
    // Since each group has carry-in C[group_index], compute local carries as:
    // c0 = carry-in to group (C[group_index])
    // c1 = G0 + P0*c0
    // c2 = G1 + P1*c1
    // c3 = G2 + P2*c2
    // sum = P ^ carry_in_bits

    wire [15:0] c_internal; // carries internal to bits except bit0 in each group
    // carry bits for each bit - indexed per bit
    // For bit 0 of each group, carry in is C[group]
    // Compute carry for bits 1..3 in each group

    generate
        for (i = 0; i < 4; i = i + 1) begin : bits_in_group
            wire c0 = C[i];
            // bit 0 carry-in known (c0)
            // bit 1 carry:
            wire c1 = G[4*i + 0] | (P[4*i + 0] & c0);
            // bit 2 carry:
            wire c2 = G[4*i + 1] | (P[4*i + 1] & c1);
            // bit 3 carry:
            wire c3 = G[4*i + 2] | (P[4*i + 2] & c2);

            assign c_internal[4*i + 0] = c0; // carry-in for bit 0
            assign c_internal[4*i + 1] = c1;
            assign c_internal[4*i + 2] = c2;
            assign c_internal[4*i + 3] = c3;
        end
    endgenerate

    // Compute sum bits:
    // sum[i] = P[i] ^ carry_in[i]
    assign S = P ^ c_internal;

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    // Map 1-based inputs to 0-based internal signals
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split into lower and upper 16 bits
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

    // Map outputs back to 1-based indexing
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate

endmodule