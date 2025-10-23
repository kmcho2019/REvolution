module cla_16bit(
    input  wire [15:0] A,    // 16-bit operand A (bits 15 down to 0)
    input  wire [15:0] B,    // 16-bit operand B
    input  wire        Cin,  // Carry-in
    output wire [15:0] S,    // 16-bit sum
    output wire        Cout, // Carry-out
    output wire        P_block, // Group propagate
    output wire        G_block  // Group generate
);

    wire [15:0] P; // propagate signals for each bit
    wire [15:0] G; // generate signals for each bit
    wire [16:0] C; // carry signals, C[0] = Cin

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i+1) begin : carry_compute
            // Carry lookahead formula:
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Group propagate = AND of all P bits
    assign P_block = &P;

    // Group generate using recursive generate logic:
    // G_block = G[15] | (P[15]&G[14]) | (P[15]&P[14]&G[13]) | ... | (P[15]&...&P[0]&Cin)
    // But since block generate is block-level generate without external carry, Cin=0
    // So compute as G_block = carry generate assuming Cin=0
    wire [15:0] gen_int;
    assign gen_int[0] = G[0];
    generate
        for (i = 1; i < 16; i = i+1) begin : gen_recursive
            assign gen_int[i] = G[i] | (P[i] & gen_int[i-1]);
        end
    endgenerate
    assign G_block = gen_int[15];

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