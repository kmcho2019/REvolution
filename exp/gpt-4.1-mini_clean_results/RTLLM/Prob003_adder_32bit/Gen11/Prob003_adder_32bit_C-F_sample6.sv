module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,    // Block propagate
    output wire        G     // Block generate
);
    // Per-bit propagate and generate
    wire [15:0] P_bit = A ^ B;
    wire [15:0] G_bit = A & B;

    // 4-bit group propagate and generate signals (4 groups)
    wire [3:0] P_grp;
    wire [3:0] G_grp;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg
            // Group propagate: AND of 4 bit propagates
            assign P_grp[i] = &P_bit[(i*4)+3 -:4];
            // Group generate: 
            // G_grp[i] = G_bit[last] 
            //          + P_bit[last]*G_bit[last-1]
            //          + P_bit[last]*P_bit[last-1]*G_bit[last-2]
            //          + P_bit[last]*P_bit[last-1]*P_bit[last-2]*G_bit[last-3]
            wire p3 = P_bit[i*4+3];
            wire p2 = P_bit[i*4+2];
            wire p1 = P_bit[i*4+1];
            wire p0 = P_bit[i*4];
            wire g3 = G_bit[i*4+3];
            wire g2 = G_bit[i*4+2];
            wire g1 = G_bit[i*4+1];
            wire g0 = G_bit[i*4];
            assign G_grp[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Carry signals for 5 group carries (C_group[0..4])
    wire [4:0] C_group;
    assign C_group[0] = Cin;
    generate
        for (i = 1; i <=4; i = i + 1) begin : carry_group
            assign C_group[i] = G_grp[i-1] | (P_grp[i-1] & C_group[i-1]);
        end
    endgenerate

    // Now calculate carries within each 4-bit group
    wire [16:0] C;  // carry signals for all bits, C[0] = Cin
    assign C[0] = Cin;

    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_bits_group
            // base carry for group i is C_group[i]
            // compute carries for bits in the group
            // C for bit j in group i is:
            // C[j+1] = G_bit[j] | (P_bit[j] & C[j])
            // but with C[4*i] = C_group[i], so we must adjust indices
            
            // Carry inside group bits:
            // bit indices for group i are [4*i + 0]..[4*i + 3]

            // First bit carry in group:
            assign C[4*i + 1] = G_bit[4*i] | (P_bit[4*i] & C_group[i]);

            // Next bits
            assign C[4*i + 2] = G_bit[4*i + 1] | (P_bit[4*i + 1] & C[4*i + 1]);
            assign C[4*i + 3] = G_bit[4*i + 2] | (P_bit[4*i + 2] & C[4*i + 2]);
            assign C[4*i + 4] = G_bit[4*i + 3] | (P_bit[4*i + 3] & C[4*i + 3]);
        end
    endgenerate

    // Sum bits
    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: AND of all P_bit
    assign P = &P_bit;

    // Block generate: G = G_grp[3] + P_grp[3]*G_grp[2] + P_grp[3]*P_grp[2]*G_grp[1] + P_grp[3]*P_grp[2]*P_grp[1]*G_grp[0]
    assign G = G_grp[3] |
               (P_grp[3] & G_grp[2]) |
               (P_grp[3] & P_grp[2] & G_grp[1]) |
               (P_grp[3] & P_grp[2] & P_grp[1] & G_grp[0]);
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based signals
    wire [31:0] A_int, B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx + 1];
            assign B_int[idx] = B[idx + 1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA; carry-in = 0
    cla_16bit cla_low (
        .A   (A_low),
        .B   (B_low),
        .Cin (1'b0),
        .S   (S_low),
        .Cout(C16),
        .P   (P_low),
        .G   (G_low)
    );

    // Carry-in to upper 16-bit block computed from lower block's G and P and Cin=0
    // Carry_in_high = G_low + P_low * 0 = G_low
    wire Cin_high = G_low;

    cla_16bit cla_high (
        .A   (A_high),
        .B   (B_high),
        .Cin (Cin_high),
        .S   (S_high),
        .Cout(C32),
        .P   (P_high),
        .G   (G_high)
    );

    // Map sum output bits back to [32:1] range
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_map_low
            assign S[idx + 1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_map_high
            assign S[idx + 17] = S_high[idx];
        end
    endgenerate
endmodule