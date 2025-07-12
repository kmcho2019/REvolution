module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] G, P;       // bit generate and propagate
    wire [4:0]  C;          // carry signals, C[0] = Cin, C[4] = carry out of 16-bit block
    wire [3:0]  GG, GP;     // group generate and propagate for 4 groups of 4 bits

    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    genvar i;
    // Compute carries within each 4-bit group using lookahead logic
    generate
        for (i = 0; i < 4; i = i +1) begin : group_carries
            // Each group covers bits [4*i +: 4]
            wire g0 = G[4*i];
            wire g1 = G[4*i + 1];
            wire g2 = G[4*i + 2];
            wire g3 = G[4*i + 3];
            wire p0 = P[4*i];
            wire p1 = P[4*i + 1];
            wire p2 = P[4*i + 2];
            wire p3 = P[4*i + 3];

            // group generate GP and GG signals for this 4-bit block
            // GP = p0 & p1 & p2 & p3
            assign GP[i] = p0 & p1 & p2 & p3;
            // GG = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0)
            assign GG[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Carry into each group using group propagate/generate and Cin
    // C[1] = carry into group 1 (bits 3:0)
    assign C[1] = GG[0] | (GP[0] & C[0]);
    assign C[2] = GG[1] | (GP[1] & C[1]);
    assign C[3] = GG[2] | (GP[2] & C[2]);
    assign C[4] = GG[3] | (GP[3] & C[3]);
    assign Cout = C[4];

    // Now compute internal carries inside each 4-bit group for sum bits
    wire [15:0] carry_internal; // carry_internal[4*i + j] = carry before bit 4*i + j

    generate
        for (i = 0; i < 4; i = i + 1) begin : bits_in_group
            // Compute carry signals for bits 4*i+0 to 4*i+3
            // c0 = carry into group = C[i]
            wire c0 = C[i];
            wire g0 = G[4*i];
            wire g1 = G[4*i+1];
            wire g2 = G[4*i+2];
            wire g3 = G[4*i+3];
            wire p0 = P[4*i];
            wire p1 = P[4*i+1];
            wire p2 = P[4*i+2];

            // Carry into bit 4*i+1
            assign carry_internal[4*i + 0] = c0;
            // carry[bit+1] = g[bit] | (p[bit] & carry[bit])
            assign carry_internal[4*i + 1] = g0 | (p0 & c0);
            assign carry_internal[4*i + 2] = g1 | (p1 & carry_internal[4*i + 1]);
            assign carry_internal[4*i + 3] = g2 | (p2 & carry_internal[4*i + 2]);
        end
    endgenerate

    // Sum bits = P xor carry_in
    generate
        for (i = 0; i < 16; i = i + 1) begin : sum_bits
            assign S[i] = P[i] ^ carry_internal[i];
        end
    endgenerate
endmodule


module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit cla_lower (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule