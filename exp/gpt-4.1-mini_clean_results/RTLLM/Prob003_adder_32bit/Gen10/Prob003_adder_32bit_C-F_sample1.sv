module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit;  // Propagate signals per bit
    wire [15:0] G_bit;  // Generate signals per bit
    wire [16:0] C;      // Carry signals

    assign P_bit = A ^ B;
    assign G_bit = A & B;
    assign C[0] = Cin;

    genvar i;
    generate
        // Carry calculation using carry-lookahead logic per bit
        for (i = 0; i < 16; i = i + 1) begin : carry_calc
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    // Block propagate is AND of all bit propagates
    assign P = &P_bit;

    // Block generate calculated as hierarchical carry-lookahead generate
    // G = G[15] + P[15]*G[14] + ... + P[15]*...*P[0]*Cin
    // We implement via prefix recursive generate:
    wire [16:0] Gc;
    assign Gc[0] = 1'b0;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : block_generate_chain
            assign Gc[i] = G_bit[i-1] | (P_bit[i-1] & Gc[i-1]);
        end
    endgenerate
    assign G = Gc[16];
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