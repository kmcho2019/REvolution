module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    // Internal propagate and generate signals for each bit
    wire [16:1] P, G;
    assign P = A ^ B;  // propagate
    assign G = A & B;  // generate

    // Group propagate and generate signals for 4-bit blocks (4 groups)
    wire [4:1] P_group, G_group;

    genvar i;
    generate
        for (i = 1; i <= 4; i = i + 1) begin : group_pg
            // bits in group i: bits 4*i-3 to 4*i
            wire p0 = P[4*i-3];
            wire p1 = P[4*i-2];
            wire p2 = P[4*i-1];
            wire p3 = P[4*i];

            wire g0 = G[4*i-3];
            wire g1 = G[4*i-2];
            wire g2 = G[4*i-1];
            wire g3 = G[4*i];

            // group propagate: all bits propagate
            assign P_group[i] = p3 & p2 & p1 & p0;

            // group generate: carry generated within group or propagated from lower bits
            assign G_group[i] = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0);
        end
    endgenerate

    // Carry signals for each group (c0 to c4)
    wire [4:0] C_group;
    assign C_group[0] = Cin;
    assign C_group[1] = G_group[1] | (P_group[1] & C_group[0]);
    assign C_group[2] = G_group[2] | (P_group[2] & C_group[1]);
    assign C_group[3] = G_group[3] | (P_group[3] & C_group[2]);
    assign C_group[4] = G_group[4] | (P_group[4] & C_group[3]);
    assign Cout = C_group[4];

    // Within each group, calculate carries for each bit
    wire [16:1] C; // carry into each bit
    assign C[0] = Cin; // carry into bit 1

    generate
        for (i = 1; i <= 4; i = i + 1) begin : bit_carry
            // Calculate carries for bits in the group i
            // bit indices in group: 4*i-3 to 4*i
            // c1 = g0 + p0*cin
            // c2 = g1 + p1*g0 + p1*p0*cin
            // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*cin
            // c4 = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*cin

            wire cin_grp = C_group[i-1];

            wire p0 = P[4*i-3];
            wire p1 = P[4*i-2];
            wire p2 = P[4*i-1];
            wire p3 = P[4*i];

            wire g0 = G[4*i-3];
            wire g1 = G[4*i-2];
            wire g2 = G[4*i-1];
            wire g3 = G[4*i];

            assign C[4*i-3] = cin_grp;
            assign C[4*i-2] = g0 | (p0 & cin_grp);
            assign C[4*i-1] = g1 | (p1 & g0) | (p1 & p0 & cin_grp);
            assign C[4*i]   = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & cin_grp);
        end
    endgenerate

    // Sum bits: S = P ^ C (carry in)
    assign S = P ^ C;

endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);

    wire C16;

    // Lower 16-bit CLA
    cla_16bit cla_lower (
        .A  (A[16:1]),
        .B  (B[16:1]),
        .Cin(1'b0),
        .S  (S[16:1]),
        .Cout(C16)
    );

    // Upper 16-bit CLA
    cla_16bit cla_upper (
        .A  (A[32:17]),
        .B  (B[32:17]),
        .Cin(C16),
        .S  (S[32:17]),
        .Cout(C32)
    );

endmodule