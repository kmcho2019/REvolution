module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P_block,
    output wire        G_block
);
    // Bit-level propagate and generate
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Group propagate and generate for 4-bit groups (4 groups)
    wire [3:0] P_group;
    wire [3:0] G_group;

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : group_pg
            // 4-bit group propagate: AND of 4 bits
            assign P_group[i] = &P[4*i +: 4];
            // 4-bit group generate:
            // G_group = G[MSB] | (P[MSB] & G[MSB-1]) | ... for bits in group
            // We'll write out explicitly:
            wire g0 = G[4*i];
            wire g1 = G[4*i+1];
            wire g2 = G[4*i+2];
            wire g3 = G[4*i+3];
            wire p0 = P[4*i];
            wire p1 = P[4*i+1];
            wire p2 = P[4*i+2];
            wire p3 = P[4*i+3];

            assign G_group[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Compute carries into each 4-bit group from Cin, using group P and G signals:
    // Carry into group0 is Cin
    // Carry into group1: c4 = G_group[0] | (P_group[0] & Cin)
    // Carry into group2: c8 = G_group[1] | (P_group[1] & c4)
    // Carry into group3: c12 = G_group[2] | (P_group[2] & c8)
    wire c0 = Cin;
    wire c4 = G_group[0] | (P_group[0] & c0);
    wire c8 = G_group[1] | (P_group[1] & c4);
    wire c12 = G_group[2] | (P_group[2] & c8);

    // Now compute carries within each 4-bit group using bit-level P and G and group carry-in
    wire [16:0] C; // C[0]=Cin, C[16]=Cout
    assign C[0] = Cin;

    // For bits 0 to 3 (group 0)
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    // Check that C[4] matches c4 for consistency (carry into next group)
    // C[4] = carry out of bit 3, should equal c4 computed by groups

    // For bits 4 to 7 (group 1)
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);
    // C[8] should equal c8

    // For bits 8 to 11 (group 2)
    assign C[9]  = G[8]  | (P[8]  & C[8]);
    assign C[10] = G[9]  | (P[9]  & C[9]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G[11] | (P[11] & C[11]);
    // C[12] should equal c12

    // For bits 12 to 15 (group 3)
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G[13] | (P[13] & C[13]);
    assign C[15] = G[14] | (P[14] & C[14]);
    assign C[16] = G[15] | (P[15] & C[15]); // Cout

    // Sum bits
    assign S = P ^ C[15:0];

    assign Cout = C[16];

    // Block propagate is AND of all P groups
    assign P_block = &P_group;

    // Block generate is computed hierarchically:
    // G_block = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3]&P_group[2]&G_group[1]) | (P_group[3]&P_group[2]&P_group[1]&G_group[0])
    assign G_block = G_group[3] |
                    (P_group[3] & G_group[2]) |
                    (P_group[3] & P_group[2] & G_group[1]) |
                    (P_group[3] & P_group[2] & P_group[1] & G_group[0]);
endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map [32:1] inputs to zero-based internal
    wire [31:0] A_int, B_int;
    genvar j;
    generate
        for (j=0; j<32; j=j+1) begin : input_mapping
            assign A_int[j] = A[j+1];
            assign B_int[j] = B[j+1];
        end
    endgenerate

    // Split inputs
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs and signals from lower CLA block
    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA: Cin=0
    cla_16bit lower_block (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P_low),
        .G_block(G_low)
    );

    // Carry-in to upper block computed from lower block signals and Cin=0
    wire Cin_high = G_low | (P_low & 1'b0);

    // Upper 16-bit CLA
    cla_16bit upper_block (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P_block(P_high),
        .G_block(G_high)
    );

    // Map outputs back to [32:1]
    generate
        for (j=0; j<16; j=j+1) begin : sum_low_map
            assign S[j+1] = S_low[j];
        end
        for (j=0; j<16; j=j+1) begin : sum_high_map
            assign S[j+17] = S_high[j];
        end
    endgenerate
endmodule