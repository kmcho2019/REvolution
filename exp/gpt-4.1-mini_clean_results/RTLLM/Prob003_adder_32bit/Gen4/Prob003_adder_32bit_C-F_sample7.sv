module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P_block,  // Group propagate
    output wire        G_block   // Group generate
);
    // Per-bit propagate and generate
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Carry signals: C[0] = Cin
    wire [16:0] C;
    assign C[0] = Cin;

    // Compute carry signals using carry lookahead logic
    // Using recursive prefix generate to avoid ripple chain bottleneck:
    // C[i+1] = G[i] | (P[i] & C[i])
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_generate
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Compute block propagate: AND of all bit propagates
    assign P_block = &P;

    // Compute block generate using prefix logic:
    // G_block = G[15] | (P[15]&G[14]) | (P[15]&P[14]&G[13]) | ... | (P[15]&...&P[0]&Cin)
    // Implement recursive intermediate generate signals:
    wire [15:0] gen_int;
    assign gen_int[0] = G[0];
    generate
        for (i = 1; i < 16; i = i + 1) begin : gen_block
            assign gen_int[i] = G[i] | (P[i] & gen_int[i-1]);
        end
    endgenerate
    assign G_block = gen_int[15];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map [32:1] input vectors to [31:0] internal vectors with zero-based indexing
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx + 1];
            assign B_int[idx] = B[idx + 1];
        end
    endgenerate

    // Split into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs from lower and upper blocks
    wire [15:0] S_low;
    wire [15:0] S_high;
    wire C16;         // Carry-out from lower block
    wire P0, G0;      // Propagate and generate from lower block
    wire P1, G1;      // Propagate and generate from upper block

    // Instantiate lower 16-bit CLA block with carry-in 0
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Compute carry-in for upper block using group propagate/generate of lower block
    wire Cin_high = G0 | (P0 & 1'b0);  // Cin is 0 in top-level adder

    // Instantiate upper 16-bit CLA block with carry-in from lower block
    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P_block(P1),
        .G_block(G1)
    );

    // Map internal sums back to [32:1] output vector
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx + 1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx + 17] = S_high[idx];
        end
    endgenerate
endmodule