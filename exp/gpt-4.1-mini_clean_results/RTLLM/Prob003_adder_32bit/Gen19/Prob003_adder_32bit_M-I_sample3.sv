module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit;  // Per-bit propagate signals
    wire [15:0] G_bit;  // Per-bit generate signals
    wire [16:0] C;      // Carry signals, C[0] = Cin

    assign P_bit = A ^ B;
    assign G_bit = A & B;
    assign C[0] = Cin;

    genvar i;
    // Compute per-bit carries: C[i+1] = G[i] + P[i]*C[i]
    generate
        for (i = 0; i < 16; i = i + 1) begin : carry_gen
            assign C[i+1] = G_bit[i] | (P_bit[i] & C[i]);
        end
    endgenerate

    assign S = P_bit ^ C[15:0];
    assign Cout = C[16];

    // Block propagate = AND of all propagates
    assign P = &P_bit;

    // Parallel prefix computation for block generate signal G:
    // Use a 4-level prefix tree over 4-bit groups (total 16 bits)
    // Define generate-propagate pairs as structs
    // We'll implement prefix operations as:
    // G_out = G_high | (P_high & G_low)
    // P_out = P_high & P_low

    // Step 1: group level: 4 groups of 4 bits each
    wire [3:0] P_group;
    wire [3:0] G_group;

    generate
        for (i = 0; i < 4; i = i + 1) begin : group_calc
            assign P_group[i] = &P_bit[i*4 +:4];
            assign G_group[i] = (G_bit[i*4 + 3]) 
                              | (P_bit[i*4 + 3] & G_bit[i*4 + 2]) 
                              | (P_bit[i*4 + 3] & P_bit[i*4 + 2] & G_bit[i*4 + 1]) 
                              | (P_bit[i*4 + 3] & P_bit[i*4 + 2] & P_bit[i*4 + 1] & G_bit[i*4 + 0]);
        end
    endgenerate

    // Step 2: prefix combine groups 0..3 to get final block generate
    // Use prefix operator:
    // G_out = G_high | (P_high & G_low)
    // P_out = P_high & P_low
    wire P_01, G_01;
    wire P_23, G_23;
    wire P_0123, G_0123;

    assign P_01 = P_group[1] & P_group[0];
    assign G_01 = G_group[1] | (P_group[1] & G_group[0]);

    assign P_23 = P_group[3] & P_group[2];
    assign G_23 = G_group[3] | (P_group[3] & G_group[2]);

    assign P_0123 = P_23 & P_01;
    assign G_0123 = G_23 | (P_23 & G_01);

    assign G = G_0123;
endmodule


module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Internal zero-based vectors [31:0] mapped from [32:1]
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into low and high 16-bit halves
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Wires for outputs from CLA blocks
    wire [15:0] S_low, S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Instantiate lower 16-bit CLA block (carry-in = 0)
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry-in for upper 16-bit block is generated from lower block signals
    wire Cin_high = G_low;  // since global Cin=0: carry_in_upper = G_low + P_low*0 = G_low

    // Instantiate upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sum outputs back to [32:1] indexing cleanly
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule