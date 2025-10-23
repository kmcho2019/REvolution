module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P, // Block propagate
    output wire        G  // Block generate
);
    wire [15:0] P_bit = A ^ B; // propagate per bit
    wire [15:0] G_bit = A & B; // generate per bit

    // Compute 4-bit group propagate and generate signals
    wire [3:0] P_group, G_group;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg
            // Group propagate = AND of bit propagates in group
            assign P_group[i] = &P_bit[i*4 +:4];
            // Group generate = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
            assign G_group[i] = 
                G_bit[i*4+3] |
                (P_bit[i*4+3] & G_bit[i*4+2]) |
                (P_bit[i*4+3] & P_bit[i*4+2] & G_bit[i*4+1]) |
                (P_bit[i*4+3] & P_bit[i*4+2] & P_bit[i*4+1] & G_bit[i*4]);
        end
    endgenerate

    // Calculate carries into each 4-bit group using carry lookahead
    wire [4:0] C_group;
    assign C_group[0] = Cin;
    assign C_group[1] = G_group[0] | (P_group[0] & C_group[0]);
    assign C_group[2] = G_group[1] | (P_group[1] & C_group[1]);
    assign C_group[3] = G_group[2] | (P_group[2] & C_group[2]);
    assign C_group[4] = G_group[3] | (P_group[3] & C_group[3]);
    assign Cout = C_group[4];

    // Calculate carries inside each 4-bit group
    wire [16:0] C_bit;
    assign C_bit[0] = Cin;

    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_in_group
            wire [3:0] Pi = P_bit[i*4 +:4];
            wire [3:0] Gi = G_bit[i*4 +:4];
            wire C_start = C_group[i];

            // Compute carries inside group with full carry lookahead logic
            assign C_bit[i*4 + 1] = Gi[0] | (Pi[0] & C_start);
            assign C_bit[i*4 + 2] = Gi[1] | (Pi[1] & Gi[0]) | (Pi[1] & Pi[0] & C_start);
            assign C_bit[i*4 + 3] = Gi[2] | (Pi[2] & Gi[1]) | (Pi[2] & Pi[1] & Gi[0]) | (Pi[2] & Pi[1] & Pi[0] & C_start);
            assign C_bit[i*4 + 4] = Gi[3] | (Pi[3] & Gi[2]) | (Pi[3] & Pi[2] & Gi[1]) | (Pi[3] & Pi[2] & Pi[1] & Gi[0]) | (Pi[3] & Pi[2] & Pi[1] & Pi[0] & C_start);
        end
    endgenerate

    // Sum bits = propagate xor carry-in
    assign S = P_bit ^ C_bit[15:0];

    // Block propagate = AND of all bit propagates
    assign P = &P_bit;

    // Block generate = G_group[3] + P_group[3]*G_group[2] + P_group[3]*P_group[2]*G_group[1] + P_group[3]*P_group[2]*P_group[1]*G_group[0]
    assign G = G_group[3] 
               | (P_group[3] & G_group[2]) 
               | (P_group[3] & P_group[2] & G_group[1]) 
               | (P_group[3] & P_group[2] & P_group[1] & G_group[0]);
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Map inputs from [32:1] to [31:0]
    wire [31:0] A_int;
    wire [31:0] B_int;

    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Compute carry-in for upper block using block propagate and generate signals with Cin=0
    wire Cin_high = G_low | (P_low & 1'b0);

    // Upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sum outputs back to [32:1]
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule