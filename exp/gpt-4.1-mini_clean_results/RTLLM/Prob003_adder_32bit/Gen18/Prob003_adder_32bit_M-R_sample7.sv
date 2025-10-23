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

    // Carry signals: C[0] = Cin, C[16] = Cout
    wire [16:0] C;

    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_loop
            // Carry for bit i+1
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    // Sum bits: S = P_bit XOR carry_in
    assign S = P_bit ^ C[15:0];

    // Carry-out of block
    assign Cout = C[16];

    // Block propagate: all P_bit bits ANDed
    assign P = &P_bit;

    // Block generate: G = G[15] + P[15]*G[14] + ... calculated via reduction
    // Using logic: G_block = G[15] | (P[15] & G[14]) | (P[15]&P[14]&G[13]) | ... or equivalently:
    // G = C[16] when Cin=0 = carry out when Cin=0, so recompute carry with Cin=0 directly here:

    wire [16:0] C_zero_cin;
    assign C_zero_cin[0] = 1'b0;
    generate
        for (i = 0; i < 16; i = i + 1) begin : block_gen_carry_loop
            assign C_zero_cin[i+1] = G_bit[i] | (P_bit[i] & C_zero_cin[i]);
        end
    endgenerate

    assign G = C_zero_cin[16];

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based indexing vectors for easier handling
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : input_map
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Split into two 16-bit blocks
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs and internal signals
    wire [15:0] S_low;
    wire [15:0] S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Instantiate lower 16-bit CLA with Cin = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Calculate carry-in to upper block: C_in_high = G_low | (P_low & 0) = G_low
    wire Cin_high = G_low;

    // Instantiate upper 16-bit CLA with carry-in = Cin_high
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sums back to [32:1] indexing
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_map_low
            assign S[i+1] = S_low[i];
        end
        for (i = 0; i < 16; i = i + 1) begin : sum_map_high
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule