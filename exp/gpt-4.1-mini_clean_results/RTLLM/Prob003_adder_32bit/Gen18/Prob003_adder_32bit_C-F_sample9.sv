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

    // Function to calculate carry signals:
    // C[i+1] = G[i] | (P[i] & C[i])
    function [16:0] calc_carry;
        input [15:0] g;
        input [15:0] p;
        input        cin;
        integer i;
        reg [16:0] c;
        begin
            c[0] = cin;
            for (i = 0; i < 16; i = i + 1) begin
                c[i+1] = g[i] | (p[i] & c[i]);
            end
            calc_carry = c;
        end
    endfunction

    // Calculate carry signals with input carry Cin
    wire [16:0] C = calc_carry(G_bit, P_bit, Cin);

    // Sum bits: sum = propagate xor carry_in
    assign S = P_bit ^ C[15:0];

    // Carry-out of block
    assign Cout = C[16];

    // Block propagate: all propagates ANDed
    assign P = &P_bit;

    // Block generate is calculated using a hierarchical approach:
    // G_block = G[15] | (P[15]&G[14]) | (P[15]&P[14]&G[13]) | ... (classic CLA block generate)
    // We'll compute this using a prefix generate approach for clarity and scalability.

    // Intermediate signals for hierarchical generate
    wire [15:0] GP_g = G_bit;
    wire [15:0] GP_p = P_bit;

    // We'll implement prefix logic to compute block generate as the carry out when Cin=0
    // This matches the carry[16] for Cin=0, so we reuse the carry function:
    wire [16:0] C0 = calc_carry(GP_g, GP_p, 1'b0);
    assign G = C0[16];

endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based vectors for slicing and processing
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar i;

    // Remap inputs from [32:1] to [31:0]
    generate
        for (i = 0; i < 32; i = i + 1) begin : input_reindex
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Slice lower and upper 16-bit segments
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Outputs and signals from CLA blocks
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

    // Carry-in to upper block: C_in_high = G_low | (P_low & 0) = G_low
    wire Cin_high = G_low;

    // Instantiate upper 16-bit CLA block with carry-in Cin_high
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sum output bits back to [32:1]
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_low_map
            assign S[i+1] = S_low[i];
        end
        for (i = 0; i < 16; i = i + 1) begin : sum_high_map
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule