module cla_16bit(
    input  wire [15:0] A,       // 16-bit operand A (bits 15 down to 0)
    input  wire [15:0] B,       // 16-bit operand B
    input  wire        Cin,     // Carry-in
    output wire [15:0] S,       // 16-bit sum
    output wire        Cout,    // Carry-out
    output wire        P_block, // Group propagate
    output wire        G_block  // Group generate
);
    // Per-bit propagate and generate signals
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Internal prefix carry signals:
    // We'll implement a Kogge-Stone prefix tree to compute carry for all bits efficiently.
    // The pairs (G,P) represent generate and propagate signals for prefixes.

    // Define intermediate group generate and propagate signals for each stage.
    // Each stage merges pairs of (G,P) to get wider prefixes.

    // Level 0 (bit level): initial signals
    wire [15:0] G0 = G;
    wire [15:0] P0 = P;

    // Helper function to combine two (G,P) pairs:
    // G_out = G_high | (P_high & G_low)
    // P_out = P_high & P_low
    // We implement this using wire assignments.

    // Level 1: combine neighbors 1 apart (distance=1)
    wire [15:0] G1;
    wire [15:0] P1;
    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level1_gen
            if (i == 0) begin
                assign G1[i] = G0[i];
                assign P1[i] = P0[i];
            end else begin
                assign G1[i] = G0[i] | (P0[i] & G0[i - 1]);
                assign P1[i] = P0[i] & P0[i - 1];
            end
        end
    endgenerate

    // Level 2: combine neighbors 3 apart (distance=2)
    wire [15:0] G2;
    wire [15:0] P2;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level2_gen
            if (i < 2) begin
                assign G2[i] = G1[i];
                assign P2[i] = P1[i];
            end else begin
                assign G2[i] = G1[i] | (P1[i] & G1[i - 2]);
                assign P2[i] = P1[i] & P1[i - 2];
            end
        end
    endgenerate

    // Level 3: combine neighbors 7 apart (distance=4)
    wire [15:0] G3;
    wire [15:0] P3;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level3_gen
            if (i < 4) begin
                assign G3[i] = G2[i];
                assign P3[i] = P2[i];
            end else begin
                assign G3[i] = G2[i] | (P2[i] & G2[i - 4]);
                assign P3[i] = P2[i] & P2[i - 4];
            end
        end
    endgenerate

    // Level 4: combine neighbors 15 apart (distance=8)
    wire [15:0] G4;
    wire [15:0] P4;

    generate
        for (i = 0; i < 16; i = i + 1) begin : level4_gen
            if (i < 8) begin
                assign G4[i] = G3[i];
                assign P4[i] = P3[i];
            end else begin
                assign G4[i] = G3[i] | (P3[i] & G3[i - 8]);
                assign P4[i] = P3[i] & P3[i - 8];
            end
        end
    endgenerate

    // Compute carries C[0..16]
    // C[0] = Cin
    // For each bit i: C[i+1] = G of prefix up to bit i OR (P of prefix up to bit i AND Cin)

    // Prefix generate signals for bits
    wire [15:0] prefix_G;
    wire [15:0] prefix_P;

    // The highest-level G4 and P4 represent the prefix up to bit i.
    // So prefix_G[i] = G4[i]
    // prefix_P[i] = P4[i]

    assign prefix_G = G4;
    assign prefix_P = P4;

    // Carries
    wire [16:0] C;
    assign C[0] = Cin;

    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_gen
            assign C[i+1] = prefix_G[i] | (prefix_P[i] & Cin);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[15:0];

    // Carry-out is C[16]
    assign Cout = C[16];

    // Block propagate is AND of all P bits (block propagate if all bits propagate)
    assign P_block = &P;

    // Block generate can be taken as prefix generate of full block plus block propagate & Cin
    // Block generate = G_block = prefix_G[15] | (prefix_P[15] & Cin)
    assign G_block = prefix_G[15] | (prefix_P[15] & Cin);

endmodule


module adder_32bit(
    input  wire [32:1] A,   // 32-bit input operand A, MSB at 32 down to LSB at 1
    input  wire [32:1] B,   // 32-bit input operand B
    output wire [32:1] S,   // 32-bit sum output
    output wire        C32   // Carry-out of the 32-bit addition
);

    // Map [32:1] inputs to zero-based internal vectors [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split into lower and upper 16-bit halves
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs from each 16-bit CLA
    wire [15:0] S_low;
    wire [15:0] S_high;

    wire C16;       // Carry-out from lower 16-bit block
    wire P0, G0;    // Propagate and generate from lower 16-bit block
    wire P1, G1;    // Propagate and generate from upper 16-bit block

    // Instantiate lower 16-bit CLA block (bits 0-15)
    cla_16bit lower_cla (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),    // Overall carry-in is zero
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Compute carry-in to upper 16-bit block using block propagate/generate signals:
    // Carry_in_upper = G0 | (P0 & Cin) where Cin = 0 => Carry_in_upper = G0
    wire Cin_upper = G0;

    // Instantiate upper 16-bit CLA block (bits 16-31)
    cla_16bit upper_cla (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_upper),
        .S(S_high),
        .Cout(C32),
        .P_block(P1),
        .G_block(G1)
    );

    // Combine lower and upper sums into output S [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : output_map_low
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : output_map_high
            assign S[idx+17] = S_high[idx];
        end
    endgenerate

endmodule