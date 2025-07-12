module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P_block,  // Block propagate
    output wire        G_block   // Block generate
);
    // Per-bit propagate and generate signals
    wire [15:0] P = A ^ B;
    wire [15:0] G = A & B;

    // Carry signals array, including initial carry-in
    wire [16:0] C;
    assign C[0] = Cin;

    genvar i;
    generate
        // Compute carries per bit using carry-lookahead logic:
        // C[i+1] = G[i] + P[i] * C[i]
        for (i = 0; i < 16; i = i + 1) begin : carry_compute
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum bits = propagate XOR carry-in to bit
    assign S = P ^ C[15:0];
    assign Cout = C[16];

    // Block propagate = AND of all bit propagates
    assign P_block = &P;

    // Block generate = hierarchical prefix generate chain:
    // G_block = G[15] + P[15]*G[14] + P[15]*P[14]*G[13] + ... + P[15]*...*P[0]*Cin
    wire [16:0] Gc;
    assign Gc[0] = 1'b0;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : block_generate_chain
            assign Gc[i] = G[i-1] | (P[i-1] & Gc[i-1]);
        end
    endgenerate
    assign G_block = Gc[16];

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map [32:1] to zero-based [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx + 1];
            assign B_int[idx] = B[idx + 1];
        end
    endgenerate

    // Split inputs into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Wires for outputs and control signals from CLA blocks
    wire [15:0] S_low, S_high;
    wire        C16;      // Carry out from lower 16-bit block
    wire        P_low, G_low;   // Block propagate/generate from lower block
    wire        P_high, G_high; // Block propagate/generate from upper block

    // Instantiate lower 16-bit CLA with Cin=0
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P_block(P_low),
        .G_block(G_low)
    );

    // Calculate carry-in for upper block from lower block signals
    // Cin_high = G_low + P_low * 0 = G_low (since Cin=0)
    wire Cin_high = G_low;

    // Instantiate upper 16-bit CLA with carry-in from lower block
    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P_block(P_high),
        .G_block(G_high)
    );

    // Map sums back to [32:1] output
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx + 1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx + 17] = S_high[idx];
        end
    endgenerate

endmodule