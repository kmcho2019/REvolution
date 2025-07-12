module cla_16bit(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P_block, // group propagate
    output wire        G_block  // group generate
);

    wire [15:0] P; // propagate signals for each bit
    wire [15:0] G; // generate signals for each bit
    wire [16:0] C; // carry signals (C[0] = Cin)

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Compute carry signals using carry-lookahead logic
    genvar i;
    generate
        for (i = 0; i < 16; i = i+1) begin : carry_generate
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum bits
    assign S = P ^ C[15:0];

    assign Cout = C[16];

    // Group propagate: AND of all bit propagates
    assign P_block = &P;

    // Group generate:
    // G_block = G[15] | (P[15]&G[14]) | (P[15]&P[14]&G[13]) | ... | (P[15]&...&P[0]&Cin)
    // To implement efficiently, use a recursive approach to compute intermediate generate signals:
    wire [15:0] gen_intermediate;

    assign gen_intermediate[0] = G[0];
    generate
        for (i = 1; i < 16; i = i+1) begin : gen_block
            assign gen_intermediate[i] = G[i] | (P[i] & gen_intermediate[i-1]);
        end
    endgenerate
    assign G_block = gen_intermediate[15];

endmodule


module adder_32bit(
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);

    // Convert inputs to zero-based internal vectors
    wire [31:0] A_int = {A[32], A[31:2], A[1]};
    wire [31:0] B_int = {B[32], B[31:2], B[1]};
    // But user inputs are [32:1] with 32 as MSB, 1 as LSB,
    // so mapping directly:
    // We'll remap explicitly:
    wire [31:0] A0to31;
    wire [31:0] B0to31;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : map_inputs
            assign A0to31[idx] = A[idx+1];
            assign B0to31[idx] = B[idx+1];
        end
    endgenerate

    wire [15:0] A_low  = A0to31[15:0];
    wire [15:0] B_low  = B0to31[15:0];
    wire [15:0] A_high = A0to31[31:16];
    wire [15:0] B_high = B0to31[31:16];

    wire [15:0] S_low;
    wire [15:0] S_high;

    wire C16;       // Carry-out from lower block
    wire P0, G0;    // Propagate and generate from lower block
    wire P1, G1;    // Propagate and generate from upper block

    // Instantiate lower 16-bit CLA
    cla_16bit lower_cla (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P0),
        .G_block(G0)
    );

    // Calculate carry-in for upper block
    // Carry-in upper = G0 | (P0 & Cin) ; Cin = 0 here, so carry_in_upper = G0
    wire Cin_upper = G0;

    // Instantiate upper 16-bit CLA
    cla_16bit upper_cla (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_upper),
        .S(S_high),
        .Cout(C32),
        .P_block(P1),
        .G_block(G1)
    );

    // Concatenate sums
    // Map back to [32:1] output
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : map_sum_low
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : map_sum_high
            assign S[idx+17] = S_high[idx];
        end
    endgenerate

endmodule