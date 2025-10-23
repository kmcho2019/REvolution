module cla_16bit(
    input  wire [15:0] A,      // 16-bit operand A (bits 15 down to 0)
    input  wire [15:0] B,      // 16-bit operand B
    input  wire        Cin,    // Carry-in
    output wire [15:0] S,      // 16-bit sum
    output wire        Cout,   // Carry-out
    output wire        P_block,// Group propagate
    output wire        G_block // Group generate
);

    // Step 1: Per-bit propagate and generate
    wire [15:0] P = A ^ B;  // propagate signals
    wire [15:0] G = A & B;  // generate signals

    // Step 2: Define 4-bit group propagate and generate signals
    // Groups: bits [3:0], [7:4], [11:8], [15:12]
    wire [3:0] P_grp; // Group propagate for each 4-bit group
    wire [3:0] G_grp; // Group generate for each 4-bit group

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg
            // Group propagate is AND of all 4 propagates
            assign P_grp[i] = &P[i*4 +:4];
            // Group generate for 4-bit group using CLA formula:
            // G_group = G[3] | (P[3]&G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0])
            wire g0 = G[i*4 + 0];
            wire g1 = G[i*4 + 1];
            wire g2 = G[i*4 + 2];
            wire g3 = G[i*4 + 3];
            wire p0 = P[i*4 + 0];
            wire p1 = P[i*4 + 1];
            wire p2 = P[i*4 + 2];
            assign G_grp[i] = g3 | (p2 & g2) | (p2 & p1 & g1) | (p2 & p1 & p0 & g0);
        end
    endgenerate

    // Step 3: Calculate carries into each 4-bit group
    // C_group[0] = Cin for bits 0-3 carry-in
    // C_group[i] for i=1..4 are carries into the next groups
    wire [4:0] C_group;
    assign C_group[0] = Cin;
    assign C_group[1] = G_grp[0] | (P_grp[0] & C_group[0]);
    assign C_group[2] = G_grp[1] | (P_grp[1] & C_group[1]);
    assign C_group[3] = G_grp[2] | (P_grp[2] & C_group[2]);
    assign C_group[4] = G_grp[3] | (P_grp[3] & C_group[3]); // Final carry-out

    // Step 4: Calculate carries within each 4-bit group at bit level
    wire [15:0] C; // bit-level carry signals: C[0] is carry-in to bit 0
    assign C[0] = Cin;

    generate
        for (i = 0; i < 4; i = i + 1) begin : bits_in_group
            // For bits in group i: bits [i*4 +:4]
            // Carry-in to the first bit in group is C_group[i]
            // Then internal carries:
            // C_bit1 = G[bit0] | (P[bit0] & C_group[i])
            // C_bit2 = G[bit1] | (P[bit1] & C_bit1)
            // C_bit3 = G[bit2] | (P[bit2] & C_bit2)
            wire c0 = C_group[i];
            wire g0 = G[i*4 + 0];
            wire p0 = P[i*4 + 0];
            wire g1 = G[i*4 + 1];
            wire p1 = P[i*4 + 1];
            wire g2 = G[i*4 + 2];
            wire p2 = P[i*4 + 2];

            assign C[i*4 + 1] = g0 | (p0 & c0);
            assign C[i*4 + 2] = g1 | (p1 & C[i*4 + 1]);
            assign C[i*4 + 3] = g2 | (p2 & C[i*4 + 2]);
            // For bit i*4+4 (which is next group first bit), carry computed in next group's C_group
            // So here we do not assign C[i*4 + 4], it's assigned in next iteration or group carry signals.
        end
    endgenerate

    // Step 5: Sum bits
    assign S = P ^ C[15:0];

    // Step 6: Carry-out is final carry-out from group 4
    assign Cout = C_group[4];

    // Step 7: Block-level propagate and generate signals for 16-bit block
    // P_block = AND of all P bits
    assign P_block = &P;
    // G_block = G_grp[3] | (P_grp[3] & G_grp[2]) | (P_grp[3] & P_grp[2] & G_grp[1]) | (P_grp[3] & P_grp[2] & P_grp[1] & G_grp[0])
    assign G_block = G_grp[3] | (P_grp[3] & G_grp[2]) | (P_grp[3] & P_grp[2] & G_grp[1]) | (P_grp[3] & P_grp[2] & P_grp[1] & G_grp[0]);

endmodule


module adder_32bit(
    input  wire [32:1] A,   // 32-bit input operand A, MSB at 32 down to LSB at 1
    input  wire [32:1] B,   // 32-bit input operand B
    output wire [32:1] S,   // 32-bit sum output
    output wire        C32   // Carry-out of the 32-bit addition
);

    // Internal zero-based vectors
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split into two 16-bit halves
    wire [15:0] A_low = A_int[15:0];
    wire [15:0] B_low = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Signals for lower 16-bit CLA
    wire [15:0] S_low;
    wire C16;
    wire P0, G0;

    cla_16bit cla_lo (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Carry-in to upper 16-bit CLA block
    wire Cin_upper = G0 | (P0 & 1'b0); // Cin=0 at top level, so Cin_upper=G0

    // Signals for upper 16-bit CLA
    wire [15:0] S_high;
    wire C32_internal;
    wire P1, G1;

    cla_16bit cla_hi (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_upper),
        .S(S_high),
        .Cout(C32_internal),
        .P_block(P1),
        .G_block(G1)
    );

    assign C32 = C32_internal;

    // Map internal sums to output [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_map_low
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_map_high
            assign S[idx+17] = S_high[idx];
        end
    endgenerate

endmodule