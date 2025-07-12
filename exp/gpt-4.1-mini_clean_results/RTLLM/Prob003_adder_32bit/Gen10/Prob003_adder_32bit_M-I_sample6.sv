module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] P = A ^ B;  // Propagate
    wire [15:0] G = A & B;  // Generate

    // 4 groups of 4 bits each
    wire [3:0] P_group, G_group;

    genvar i;
    // Compute group propagate and generate for each 4-bit group
    generate
        for (i = 0; i < 4; i = i + 1) begin : grp_pg
            assign P_group[i] = &P[i*4 +:4]; // AND of 4 propagate bits
            assign G_group[i] = G[i*4 + 3] |
                               (P[i*4 + 3] & G[i*4 + 2]) |
                               (P[i*4 + 3] & P[i*4 + 2] & G[i*4 + 1]) |
                               (P[i*4 + 3] & P[i*4 + 2] & P[i*4 + 1] & G[i*4]);
        end
    endgenerate

    // Carry signals for groups [0..4]
    wire [4:0] C;
    assign C[0] = Cin;

    // Carry lookahead for group carry-ins (4-bit groups)
    assign C[1] = G_group[0] | (P_group[0] & C[0]);
    assign C[2] = G_group[1] | (P_group[1] & C[1]);
    assign C[3] = G_group[2] | (P_group[2] & C[2]);
    assign C[4] = G_group[3] | (P_group[3] & C[3]);

    // Individual carries within each group
    wire [15:0] c_internal;

    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_carry
            // Compute carry for bits within group i
            // c_internal[i*4 + 0] = carry-in for bit 0 in group = C[i]
            assign c_internal[i*4 + 0] = C[i];

            assign c_internal[i*4 + 1] = G[i*4 + 0] | (P[i*4 + 0] & c_internal[i*4 + 0]);
            assign c_internal[i*4 + 2] = G[i*4 + 1] | (P[i*4 + 1] & c_internal[i*4 + 1]);
            assign c_internal[i*4 + 3] = G[i*4 + 2] | (P[i*4 + 2] & c_internal[i*4 + 2]);
        end
    endgenerate

    assign S = P ^ c_internal; // sum bits
    assign Cout = C[4];        // carry-out from MSB group
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire c16;
    // Map 1-based indexing inputs to zero-based for the 16-bit blocks
    wire [15:0] A_low  = A[16:1];
    wire [15:0] B_low  = B[16:1];
    wire [15:0] A_high = A[32:17];
    wire [15:0] B_high = B[32:17];

    wire [15:0] S_low, S_high;

    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(c16)
    );

    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(c16),
        .S(S_high),
        .Cout(C32)
    );

    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;
endmodule