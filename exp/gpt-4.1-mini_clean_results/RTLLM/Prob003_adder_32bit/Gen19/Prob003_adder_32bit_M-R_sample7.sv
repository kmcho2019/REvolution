module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout,
    output wire        P,   // Block propagate
    output wire        G    // Block generate
);
    // Per-bit propagate and generate
    wire [15:0] p = A ^ B;
    wire [15:0] g = A & B;

    // Group propagate and generate for 4-bit groups
    wire [3:0] P_group;
    wire [3:0] G_group;

    genvar i;
    generate
        for (i = 0; i < 4; i=i+1) begin : group_pg
            // Group propagate: all bits propagate in group
            assign P_group[i] = &p[(i*4)+3 -: 4];
            // Group generate:
            // G = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0
            assign G_group[i] =
                g[(i*4)+3] |
                (p[(i*4)+3] & g[(i*4)+2]) |
                (p[(i*4)+3] & p[(i*4)+2] & g[(i*4)+1]) |
                (p[(i*4)+3] & p[(i*4)+2] & p[(i*4)+1] & g[(i*4)]);
        end
    endgenerate

    // Carry signals at group boundaries: C0=Cin, C4, C8, C12, C16
    wire C0 = Cin;
    wire C4, C8, C12, C16;

    // Carry into each 4-bit group using block carry-lookahead logic
    assign C4  = G_group[0] | (P_group[0] & C0);
    assign C8  = G_group[1] | (P_group[1] & C4);
    assign C12 = G_group[2] | (P_group[2] & C8);
    assign C16 = G_group[3] | (P_group[3] & C12);

    // Carry signals for each bit
    wire [16:0] C;
    assign C[0]  = C0;
    // For each bit inside groups, compute carry signals by 4-bit CLA logic
    // For group 0 (bits 0-3)
    assign C[1] = g[0] | (p[0] & C[0]);
    assign C[2] = g[1] | (p[1] & C[1]);
    assign C[3] = g[2] | (p[2] & C[2]);
    assign C[4] = C4; // group carry out already assigned

    // For group 1 (bits 4-7)
    assign C[5] = g[4] | (p[4] & C[4]);
    assign C[6] = g[5] | (p[5] & C[5]);
    assign C[7] = g[6] | (p[6] & C[6]);
    assign C[8] = C8;

    // For group 2 (bits 8-11)
    assign C[9]  = g[8]  | (p[8]  & C[8]);
    assign C[10] = g[9]  | (p[9]  & C[9]);
    assign C[11] = g[10] | (p[10] & C[10]);
    assign C[12] = C12;

    // For group 3 (bits 12-15)
    assign C[13] = g[12] | (p[12] & C[12]);
    assign C[14] = g[13] | (p[13] & C[13]);
    assign C[15] = g[14] | (p[14] & C[14]);
    assign C[16] = C16;

    // Sum bits
    assign S = p ^ C[15:0];

    assign Cout = C16;

    // Block propagate (all bits propagate)
    assign P = &p;

    // Block generate: use group generates/propagates and carry-in zero to generate the overall block generate
    // Using same structure with Cin=0 to get block generate:
    wire c4_0, c8_0, c12_0, c16_0;
    assign c4_0  = G_group[0] | (P_group[0] & 1'b0);      // = G_group[0]
    assign c8_0  = G_group[1] | (P_group[1] & c4_0);
    assign c12_0 = G_group[2] | (P_group[2] & c8_0);
    assign c16_0 = G_group[3] | (P_group[3] & c12_0);

    assign G = c16_0;

endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    // Convert to zero-based indexing internally
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin : input_map
            assign A_int[i] = A[i+1];
            assign B_int[i] = B[i+1];
        end
    endgenerate

    // Split inputs into lower and upper 16-bit blocks
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    // Internal wires
    wire [15:0] S_low;
    wire [15:0] S_high;
    wire        C16;
    wire        P_low, G_low;
    wire        P_high, G_high;

    // Instantiate lower 16-bit CLA with Cin=0
    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P_low),
        .G(G_low)
    );

    // Carry-in for upper block: C16 = G_low + P_low * 0 = G_low
    wire Cin_high = G_low;

    // Instantiate upper 16-bit CLA with carry-in = Cin_high
    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P_high),
        .G(G_high)
    );

    // Map sums back to [32:1]
    generate
        for (i=0; i<16; i=i+1) begin : sum_map_low
            assign S[i+1] = S_low[i];
        end
        for (i=0; i<16; i=i+1) begin : sum_map_high
            assign S[i+17] = S_high[i];
        end
    endgenerate

endmodule