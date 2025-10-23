module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    // Per-bit propagate and generate signals
    wire [15:0] P_bit = A ^ B;
    wire [15:0] G_bit = A & B;

    // Prefix carry calculation using a balanced tree (Kogge-Stone style)
    // Stage wires: Each stage halves the distance
    wire [15:0] P_stage1, G_stage1;
    wire [15:0] P_stage2, G_stage2;
    wire [15:0] P_stage3, G_stage3;
    wire [15:0] P_stage4, G_stage4;

    // Level 0 (input): P_bit, G_bit

    // Level 1: combine pairs of adjacent bits
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : level1
            if (i == 0) begin
                assign P_stage1[i] = P_bit[i];
                assign G_stage1[i] = G_bit[i];
            end else begin
                assign P_stage1[i] = P_bit[i] & P_bit[i-1];
                assign G_stage1[i] = G_bit[i] | (P_bit[i] & G_bit[i-1]);
            end
        end
    endgenerate

    // Level 2: combine in groups of 4
    generate
        for (i = 0; i < 16; i = i + 1) begin : level2
            if (i < 2) begin
                assign P_stage2[i] = P_stage1[i];
                assign G_stage2[i] = G_stage1[i];
            end else begin
                assign P_stage2[i] = P_stage1[i] & P_stage1[i-2];
                assign G_stage2[i] = G_stage1[i] | (P_stage1[i] & G_stage1[i-2]);
            end
        end
    endgenerate

    // Level 3: combine in groups of 8
    generate
        for (i = 0; i < 16; i = i + 1) begin : level3
            if (i < 4) begin
                assign P_stage3[i] = P_stage2[i];
                assign G_stage3[i] = G_stage2[i];
            end else begin
                assign P_stage3[i] = P_stage2[i] & P_stage2[i-4];
                assign G_stage3[i] = G_stage2[i] | (P_stage2[i] & G_stage2[i-4]);
            end
        end
    endgenerate

    // Level 4: combine in groups of 16
    generate
        for (i = 0; i < 16; i = i + 1) begin : level4
            if (i < 8) begin
                assign P_stage4[i] = P_stage3[i];
                assign G_stage4[i] = G_stage3[i];
            end else begin
                assign P_stage4[i] = P_stage3[i] & P_stage3[i-8];
                assign G_stage4[i] = G_stage3[i] | (P_stage3[i] & G_stage3[i-8]);
            end
        end
    endgenerate

    // Carry computation: c[i+1] = G for bit i plus propagate chain to previous carry
    wire [16:0] C;
    assign C[0] = Cin;

    // Calculate carries from prefix signals:
    // For each bit, find carry-in using prefix G and P
    assign C[1]  = G_bit[0] | (P_bit[0]  & C[0]);
    assign C[2]  = G_stage1[1] | (P_stage1[1] & C[0]);
    assign C[3]  = G_stage1[2] | (P_stage1[2] & C[1]);
    assign C[4]  = G_stage2[3] | (P_stage2[3] & C[0]);
    assign C[5]  = G_stage1[4] | (P_stage1[4] & C[3]);
    assign C[6]  = G_stage2[5] | (P_stage2[5] & C[1]);
    assign C[7]  = G_stage2[6] | (P_stage2[6] & C[2]);
    assign C[8]  = G_stage3[7] | (P_stage3[7] & C[0]);
    assign C[9]  = G_stage1[8] | (P_stage1[8] & C[7]);
    assign C[10] = G_stage2[9] | (P_stage2[9] & C[5]);
    assign C[11] = G_stage2[10] | (P_stage2[10] & C[6]);
    assign C[12] = G_stage3[11] | (P_stage3[11] & C[3]);
    assign C[13] = G_stage2[12] | (P_stage2[12] & C[8]);
    assign C[14] = G_stage3[13] | (P_stage3[13] & C[9]);
    assign C[15] = G_stage3[14] | (P_stage3[14] & C[10]);
    assign C[16] = G_stage4[15] | (P_stage4[15] & C[0]);

    // Sum bits
    assign S = P_bit ^ C[15:0];

    // Block propagate: AND of all P_bit
    assign P = &P_bit;

    // Block generate: final carry-out at bit 16 (Cout)
    assign G = G_stage4[15];

    assign Cout = C[16];

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map input vectors from [32:1] to [31:0] zero-based indexing internally
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

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA block; carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry-in to upper block: Cin_high = G_low + P_low * 0 = G_low
    wire Cin_high = G_low;

    // Upper 16-bit CLA block; carry-in from lower block P/G logic
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sum outputs back to [32:1] range
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule