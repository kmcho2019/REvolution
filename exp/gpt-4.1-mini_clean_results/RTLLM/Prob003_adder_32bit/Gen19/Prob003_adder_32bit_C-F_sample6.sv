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

    // Carry signals: C[0] is Cin, C[16] is carry out
    wire [16:0] C;
    assign C[0] = Cin;

    genvar i;
    generate
        // Compute carry signals with carry-lookahead logic
        for (i = 0; i < 16; i = i + 1) begin : carry_logic
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    // Sum bits
    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: AND of all bit propagates
    assign P = &P_bit;

    // Block generate: prefix reduction of G and P (balanced tree style)
    // Here computed by recursive generate loop similar to carry but independent of Cin,
    // by assuming Cin=0 to get block generate (carry generate independent of Cin)
    // We replicate carry logic with Cin=0 to get G:
    wire [16:0] temp_G; 
    assign temp_G[0] = 1'b0;
    generate
        for (i = 0; i < 16; i = i + 1) begin : block_generate
            assign temp_G[i+1] = G_bit[i] | (P_bit[i] & temp_G[i]);
        end
    endgenerate
    assign G = temp_G[16];
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Convert from 1-based indexing to 0-based internal vectors for convenience
    wire [31:0] A_int = A[32:1];
    wire [31:0] B_int = B[32:1];

    // Split into lower and upper 16-bit blocks
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA block, Cin = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Calculate carry-in for upper block using lower block propagate and generate
    wire Cin_high = G_low | (P_low & 1'b0); // Since global carry-in = 0

    // Upper 16-bit CLA block, carry-in from lower block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map internal sums back to output using 1-based indexing
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;

endmodule