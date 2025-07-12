module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P;       // Propagate signals
    wire [16:1] G;       // Generate signals

    // Group propagate and generate for 4-bit groups (4 groups)
    wire [4:1] P_group;
    wire [4:1] G_group;
    wire [4:0] C;  // Carry signals: C[0] = Cin, C[4] = Cout

    assign C[0] = Cin;

    genvar i;

    // Generate propagate and generate per bit
    generate
        for (i = 1; i <= 16; i = i + 1) begin : pg_bits
            assign P[i] = A[i] ^ B[i];
            assign G[i] = A[i] & B[i];
        end
    endgenerate

    // Compute group propagate and generate signals for each 4-bit group
    // Group i covers bits: 4*i-3 to 4*i (e.g., group 1 bits 1-4)
    // P_group[i] = P_bit4 & P_bit3 & P_bit2 & P_bit1
    // G_group[i] = G_bit4 | (P_bit4 & G_bit3) | (P_bit4 & P_bit3 & G_bit2) | (P_bit4 & P_bit3 & P_bit2 & G_bit1)
    generate
        for (i = 1; i <= 4; i = i + 1) begin : group_pg
            wire p3 = P[4*i];
            wire p2 = P[4*i-1];
            wire p1 = P[4*i-2];
            wire p0 = P[4*i-3];

            wire g3 = G[4*i];
            wire g2 = G[4*i-1];
            wire g1 = G[4*i-2];
            wire g0 = G[4*i-3];

            assign P_group[i] = p3 & p2 & p1 & p0;
            assign G_group[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Compute carries between groups using group propagate and generate
    // C[1] to C[4] are group carries after group 1 to 4
    assign C[1] = G_group[1] | (P_group[1] & C[0]);
    assign C[2] = G_group[2] | (P_group[2] & C[1]);
    assign C[3] = G_group[3] | (P_group[3] & C[2]);
    assign C[4] = G_group[4] | (P_group[4] & C[3]);
    assign Cout = C[4];

    // Now within each 4-bit group, compute carries for individual bits
    // C_in to the group is C[group_index - 1]
    // C_sub[j]: carries within the group bits 0..4, C_sub[0] = group's carry-in
    wire [4:0] C_sub [1:4];
    generate
        for (i = 1; i <= 4; i = i + 1) begin : bit_carries
            assign C_sub[i][0] = C[i-1];
            assign C_sub[i][1] = G[4*i-3] | (P[4*i-3] & C_sub[i][0]);
            assign C_sub[i][2] = G[4*i-2] | (P[4*i-2] & C_sub[i][1]);
            assign C_sub[i][3] = G[4*i-1] | (P[4*i-1] & C_sub[i][2]);
            assign C_sub[i][4] = G[4*i]   | (P[4*i]   & C_sub[i][3]);
        end
    endgenerate

    // Generate sum bits: S[i] = P[i] ^ carry_in_to_bit[i]
    generate
        for (i = 1; i <= 16; i = i + 1) begin : sum_bits
            // Determine which group the bit belongs to:
            // group = (i-1)/4 + 1
            // bit index within group = (i-1) % 4
            wire [2:0] group_idx = (i-1) / 4 + 1;
            wire [2:0] bit_idx = (i-1) % 4;
            // Use carry_in for bit i from C_sub[group_idx][bit_idx]
            // Because bit_idx 0 corresponds to carry_in for that bit
            // sum bit is P[i] ^ C_in_bit[i]
            assign S[i] = P[i] ^ C_sub[group_idx][bit_idx];
        end
    endgenerate

endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Lower 16-bit CLA
    cla_16bit cla_lower (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    // Upper 16-bit CLA
    cla_16bit cla_upper (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );

endmodule