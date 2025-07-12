module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit = A ^ B;  // Propagate signals per bit
    wire [15:0] G_bit = A & B;  // Generate signals per bit

    wire [16:0] C;              // Carry signals vector
    assign C[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_logic
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    // Block propagate: AND of all bit propagates
    assign P = &P_bit;

    // Block generate using hierarchical reduction:
    // G = G15 | (P15 & G14) | (P15 & P14 & G13) | ... | (P15 &...& P0 & Cin)
    // Since Cin=0 in top-level, we can ignore the last term for global block generate
    // Here we express G as the last carry out minus Cin effect:
    // G = C[16] when Cin=0, or more generally:
    // G = carry generate ignoring Cin propagation (C[16] with Cin=0)
    // So here Cin is variable, so implement explicitly via generate chain
    // However, for combinational clarity, assign G = C[16] when Cin=0, else we must do prefix
    // We compute G as carry generate independent of Cin by checking carry generated solely by G_bit and P_bit
    // This is identical to C[16] when Cin=0, but as Cin can vary, we compute G using the chain:

    // Implement the recursive prefix generate logic directly for block G:
    wire [16:0] temp_G; // Intermediate prefix generates with Cin=0
    assign temp_G[0] = 1'b0;
    generate
        for (i = 1; i <= 16; i = i + 1) begin : prefix_generate
            assign temp_G[i] = G_bit[i-1] | (P_bit[i-1] & temp_G[i-1]);
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
    // Internal zero-based vectors mapped from 1-based inputs using bit slicing
    wire [31:0] A_int = A[32:1];
    wire [31:0] B_int = B[32:1];

    // Split inputs into two 16-bit halves
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

    // Calculate carry-in for upper block from lower block's propagate/generate signals
    wire Cin_high = G_low | (P_low & 1'b0); // Since global Cin=0

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

    // Map sums back to 1-based output vector using bit slicing
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;

endmodule