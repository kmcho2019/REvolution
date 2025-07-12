module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout,
    output        P,  // Block propagate
    output        G   // Block generate
);
    // Per-bit propagate and generate
    wire [15:0] p = A ^ B;
    wire [15:0] g = A & B;

    // Group propagate and generate wires for hierarchical carry
    wire [3:0] gp; // group propagate for 4 groups of 4 bits
    wire [3:0] gg; // group generate for 4 groups of 4 bits

    // Compute group propagate/generate for 4-bit groups
    genvar i;
    generate
        for(i=0; i<4; i=i+1) begin : grp_pg
            assign gp[i] = &p[i*4 +: 4];
            assign gg[i] = g[i*4 + 3]
                         | (p[i*4 + 3] & g[i*4 + 2])
                         | (p[i*4 + 3] & p[i*4 + 2] & g[i*4 + 1])
                         | (p[i*4 + 3] & p[i*4 + 2] & p[i*4 + 1] & g[i*4 + 0]);
        end
    endgenerate

    // Compute carries at group boundaries (carries between groups)
    wire [4:0] c_group;
    assign c_group[0] = Cin;

    // Hierarchical carry for groups
    assign c_group[1] = gg[0] | (gp[0] & c_group[0]);
    assign c_group[2] = gg[1] | (gp[1] & c_group[1]);
    assign c_group[3] = gg[2] | (gp[2] & c_group[2]);
    assign c_group[4] = gg[3] | (gp[3] & c_group[3]);

    // Compute carries within each 4-bit group
    wire [16:0] c; // carries per bit, c[0] = Cin, c[16] = Cout
    assign c[0] = Cin;

    generate
        for (i=0; i<4; i=i+1) begin : carry_within_group
            // carries inside group i: bits [i*4 .. i*4+3]
            wire [3:0] p_group = p[i*4 +: 4];
            wire [3:0] g_group = g[i*4 +: 4];
            assign c[i*4 + 1] = g_group[0] | (p_group[0] & c_group[i]);
            assign c[i*4 + 2] = g_group[1] | (p_group[1] & c[i*4 + 1]);
            assign c[i*4 + 3] = g_group[2] | (p_group[2] & c[i*4 + 2]);
            assign c[i*4 + 4] = g_group[3] | (p_group[3] & c[i*4 + 3]);
        end
    endgenerate

    // Sum bits
    assign S = p ^ c[15:0];

    assign Cout = c[16];

    // Block propagate is AND of all p bits
    assign P = &p;

    // Block generate = G of entire block = gg[3] | (gp[3] & c_group[3])
    // But c_group[4] is carry-out, so block generate is:
    // G = gg[3] | (gp[3] & gg[2]) | (gp[3]&gp[2]&gg[1]) | (gp[3]&gp[2]&gp[1]&gg[0])
    // Alternatively, since we have c_group[4], and Cin=0 for block generate definition, we recompute G with Cin=0:
    // To keep simpler, define G as carry generate independent of Cin = (carry-out when Cin=0)
    wire [16:0] c0;
    assign c0[0] = 1'b0;

    // Compute group generate with Cin=0
    wire [4:0] c0_group;
    assign c0_group[0] = 1'b0;
    assign c0_group[1] = gg[0] | (gp[0] & c0_group[0]);
    assign c0_group[2] = gg[1] | (gp[1] & c0_group[1]);
    assign c0_group[3] = gg[2] | (gp[2] & c0_group[2]);
    assign c0_group[4] = gg[3] | (gp[3] & c0_group[3]);

    generate
        for (i=0; i<4; i=i+1) begin : carry0_within_group
            wire [3:0] p_group = p[i*4 +: 4];
            wire [3:0] g_group = g[i*4 +: 4];
            assign c0[i*4 + 1] = g_group[0] | (p_group[0] & c0_group[i]);
            assign c0[i*4 + 2] = g_group[1] | (p_group[1] & c0[i*4 + 1]);
            assign c0[i*4 + 3] = g_group[2] | (p_group[2] & c0[i*4 + 2]);
            assign c0[i*4 + 4] = g_group[3] | (p_group[3] & c0[i*4 + 3]);
        end
    endgenerate

    assign G = c0[16];

endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Internal signals: remap top-level to zero-based indexing for internal CLA
    wire [15:0] A_low  = A[16:1];
    wire [15:0] B_low  = B[16:1];
    wire [15:0] A_high = A[32:17];
    wire [15:0] B_high = B[32:17];

    wire [15:0] S_low;
    wire [15:0] S_high;

    wire C16;       // carry out from lower block
    wire P0, G0;    // propagate and generate of lower block
    wire P1, G1;    // propagate and generate of upper block

    // Instantiate lower 16-bit CLA block with carry-in = 0
    cla_16bit cla_low (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16),
        .P(P0),
        .G(G0)
    );

    // Calculate carry-in for upper block:
    // carry_in_upper = G0 | (P0 & 0) = G0
    wire Cin_high = G0;

    // Instantiate upper 16-bit CLA block
    cla_16bit cla_high (
        .A(A_high),
        .B(B_high),
        .Cin(Cin_high),
        .S(S_high),
        .Cout(C32),
        .P(P1),
        .G(G1)
    );

    // Assign sums back with 1-based indexing
    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;

endmodule