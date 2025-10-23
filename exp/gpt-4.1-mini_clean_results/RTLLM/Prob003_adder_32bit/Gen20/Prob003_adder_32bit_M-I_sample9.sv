module cla_4bit (
    input  wire [3:0] P,  // propagate signals per bit
    input  wire [3:0] G,  // generate signals per bit
    input  wire       Cin,
    output wire [4:1] carry, // carry signals c1 to c4
    output wire       P_group,
    output wire       G_group
);
    // Compute carry signals using carry-lookahead:
    // c1 = G0 + P0*Cin
    // c2 = G1 + P1*G0 + P1*P0*Cin
    // c3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    // c4 = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*Cin

    assign carry[1] = G[0] | (P[0] & Cin);
    assign carry[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign carry[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign carry[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    assign P_group = &P;           // group propagate: AND of all propagate bits
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]); // group generate
endmodule

module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,  // Block propagate
    output wire        G   // Block generate
);
    wire [15:0] P_bit, G_bit;

    // Per-bit propagate and generate
    assign P_bit = A ^ B;
    assign G_bit = A & B;

    // Group into 4 groups of 4 bits
    wire [3:0] P_group, G_group;
    wire [4:1] carry_group; // carries between groups
    wire [15:0] carry_bit;

    genvar i;
    // Instantiate four 4-bit CLA blocks for groups
    generate
        for(i=0; i<4; i=i+1) begin : group_cla
            cla_4bit cla4 (
                .P(P_bit[i*4 +:4]),
                .G(G_bit[i*4 +:4]),
                .Cin(i==0 ? Cin : carry_group[i]),
                .carry(carry_bit[i*4 +1 +:4]),
                .P_group(P_group[i]),
                .G_group(G_group[i])
            );
        end
    endgenerate

    // Compute group carries using 4-bit CLA on group generate/propagate
    // carry_group[1] to carry_group[4]
    cla_4bit group_carry (
        .P(P_group),
        .G(G_group),
        .Cin(Cin),
        .carry(carry_group),
        .P_group(), // unused here
        .G_group()  // unused here
    );

    // Connect each 4-bit CLA group's carry-in from group carry outputs
    // (already done inside generate loop via carry_group[i], i=1..3)
    // carry_bit holds c1 to c4 for each group

    // Calculate sums
    // For each bit: sum = P_bit ^ carry_in
    // carry_in for bit i is carry_bit[i]
    // The first carry_in (for bit 0) is Cin

    // Assign carry_bit[0] = Cin for indexing convenience
    wire [15:0] carry_for_sum;
    assign carry_for_sum[0] = Cin;
    assign carry_for_sum[15:1] = carry_bit[1:15];

    generate
        for(i=0; i<16; i=i+1) begin : sum_calc
            assign S[i] = P_bit[i] ^ carry_for_sum[i];
        end
    endgenerate

    // Final carry out is carry from last bit = carry_bit[15+1] = carry_bit[16], but we only have up to 15:1 indexing in carry_bit
    // The carry out from last group carry is carry_group[4]
    // The carry out of last bit is carry_group[4] because last 4-bit CLA carry-out = carry_group[4]

    assign Cout = carry_group[4];

    // Block propagate and generate signals for the entire 16-bit block
    assign P = &P_group; // block propagate = AND of group propagates
    assign G = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & G_group[0]);

endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int, B_int;
    genvar i;

    // Remap input bits [32:1] to zero-based [31:0]
    generate
        for (i=0; i<32; i=i+1) begin : input_reindex
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Split into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    // Lower 16-bit CLA block with Cin=0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Upper 16-bit CLA block with carry-in = C16 (from lower block)
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sums back to output [32:1]
    generate
        for (i=0; i<16; i=i+1) begin : sum_low_map
            assign S[i+1] = S_low[i];
        end
        for (i=0; i<16; i=i+1) begin : sum_high_map
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule