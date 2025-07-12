module cla_16bit (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        Cin,
    output wire [15:0] S,
    output wire        Cout
);
    wire [15:0] P; // Propagate signals (bit)
    wire [15:0] G; // Generate signals (bit)

    // Group Propagate and Generate for 4-bit groups (4 groups)
    wire [3:0] PG; // Group Propagate
    wire [3:0] GG; // Group Generate

    wire [4:0] C; // Carry signals: C[0] = Cin, C[4] = Cout

    assign P = A ^ B;
    assign G = A & B;

    // Calculate group propagate and generate signals for 4-bit blocks
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_pg_gen
            wire [3:0] p = P[i*4 +: 4];
            wire [3:0] g = G[i*4 +: 4];
            // Group propagate = p3 & p2 & p1 & p0
            assign PG[i] = &p;
            // Group generate = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
            assign GG[i] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
        end
    endgenerate

    // Carry generation for groups: C[0] = Cin
    assign C[0] = Cin;
    assign C[1] = GG[0] | (PG[0] & C[0]);
    assign C[2] = GG[1] | (PG[1] & C[1]);
    assign C[3] = GG[2] | (PG[2] & C[2]);
    assign C[4] = GG[3] | (PG[3] & C[3]);
    assign Cout = C[4];

    // Now calculate carries inside each 4-bit group
    wire [15:0] carry_bits;
    generate
        for (i = 0; i < 4; i = i + 1) begin : carry_within_group
            // carries within the group, starting from C[i]
            wire c0 = C[i];
            wire [3:0] p = P[i*4 +: 4];
            wire [3:0] g = G[i*4 +: 4];

            // C[i*4 + 1] = g0 | (p0 & c0)
            assign carry_bits[i*4]   = c0;
            assign carry_bits[i*4+1] = g[0] | (p[0] & c0);
            assign carry_bits[i*4+2] = g[1] | (p[1] & carry_bits[i*4+1]);
            assign carry_bits[i*4+3] = g[2] | (p[2] & carry_bits[i*4+2]);
        end
    endgenerate

    // Sum calculation
    assign S = P ^ carry_bits[15:0];
endmodule

module adder_32bit (
    input  wire [32:1] A,
    input  wire [32:1] B,
    output wire [32:1] S,
    output wire        C32
);
    wire [31:0] A_int;
    wire [31:0] B_int;
    genvar idx;

    // Map 1-based inputs to 0-based internal vectors
    generate
        for (idx = 0; idx < 32; idx = idx + 1) begin : input_map
            assign A_int[idx] = A[idx+1];
            assign B_int[idx] = B[idx+1];
        end
    endgenerate

    // Split inputs into lower and upper 16 bits
    wire [15:0] A_low  = A_int[15:0];
    wire [15:0] B_low  = B_int[15:0];
    wire [15:0] A_high = A_int[31:16];
    wire [15:0] B_high = B_int[31:16];

    wire [15:0] S_low, S_high;
    wire C16;

    // Lower 16-bit CLA block, carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    // Upper 16-bit CLA block, carry-in = carry-out of lower block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    // Map internal sum outputs back to 1-based outputs
    generate
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_low_map
            assign S[idx+1] = S_low[idx];
        end
        for (idx = 0; idx < 16; idx = idx + 1) begin : sum_high_map
            assign S[idx+17] = S_high[idx];
        end
    endgenerate
endmodule