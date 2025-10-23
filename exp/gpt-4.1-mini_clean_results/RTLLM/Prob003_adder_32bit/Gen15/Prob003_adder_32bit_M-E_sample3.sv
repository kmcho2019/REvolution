module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout,
    output        G_out,
    output        P_out
);
    wire [15:0] G = A & B;       // Generate signals per bit
    wire [15:0] P = A ^ B;       // Propagate signals per bit

    // Carry signals for bits 0 to 16 (C[0] = Cin)
    wire [16:0] C;
    assign C[0] = Cin;

    // Internal generate/propagate group signals for 4-bit groups
    wire [3:0] Gg; // Group generate
    wire [3:0] Pg; // Group propagate

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : group_calc
            // group generate for bits 4*i+3 down to 4*i
            // Gg = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
            assign Gg[i] = G[4*i+3] |
                           (P[4*i+3] & G[4*i+2]) |
                           (P[4*i+3] & P[4*i+2] & G[4*i+1]) |
                           (P[4*i+3] & P[4*i+2] & P[4*i+1] & G[4*i]);

            // group propagate = P3 & P2 & P1 & P0
            assign Pg[i] = P[4*i+3] & P[4*i+2] & P[4*i+1] & P[4*i];
        end
    endgenerate

    // Carry into each 4-bit group
    wire [4:0] Cg;
    assign Cg[0] = Cin;
    assign Cg[1] = Gg[0] | (Pg[0] & Cg[0]);
    assign Cg[2] = Gg[1] | (Pg[1] & Cg[1]);
    assign Cg[3] = Gg[2] | (Pg[2] & Cg[2]);
    assign Cg[4] = Gg[3] | (Pg[3] & Cg[3]);

    // Calculate carry for each bit within 4-bit groups
    generate
        for (i = 0; i < 4; i = i + 1) begin: bit_carry_loop
            // Bit 0 carry in each group is Cg[i]
            // Calculate carries inside group for bits 1 to 3:
            // c1 = g0 + p0*c0
            // c2 = g1 + p1*c1
            // c3 = g2 + p2*c2

            wire c0 = Cg[i];
            wire c1 = G[4*i] | (P[4*i] & c0);
            wire c2 = G[4*i+1] | (P[4*i+1] & c1);
            wire c3 = G[4*i+2] | (P[4*i+2] & c2);

            assign C[4*i+1] = c0;
            assign C[4*i+2] = c1;
            assign C[4*i+3] = c2;
            assign C[4*i+4] = c3;
        end
    endgenerate

    // Sum bits: S[i] = P[i] ^ C[i]
    assign S = P ^ C[15:0];

    assign Cout = C[16];

    // Output group generate and propagate for the entire 16 bits
    // G_out = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3]&Pg[2]&Gg[1]) | (Pg[3]&Pg[2]&Pg[1]&Gg[0])
    assign G_out = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3] & Pg[2] & Gg[1]) | (Pg[3] & Pg[2] & Pg[1] & Gg[0]);
    // P_out = Pg[3] & Pg[2] & Pg[1] & Pg[0]
    assign P_out = Pg[3] & Pg[2] & Pg[1] & Pg[0];
endmodule


module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    // Wires for lower 16-bit block
    wire [15:0] S_lower;
    wire        C_lower;
    wire        G_lower, P_lower;

    // Wires for upper 16-bit block
    wire [15:0] S_upper;
    wire        C_upper;
    wire        G_upper, P_upper;

    // Instantiate lower 16-bit CLA
    cla_16bit cla_low(
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S_lower),
        .Cout(C_lower),
        .G_out(G_lower),
        .P_out(P_lower)
    );

    // Carry Lookahead for top level (compute carry in to upper 16-bit block, C16)
    // Using group generate/propagate signals of both blocks to compute carries:
    wire C16;
    assign C16 = G_lower | (P_lower & 1'b0);  // since Cin = 0

    // For carry out (C32):
    assign C32 = G_upper | (P_upper & C16);

    // Instantiate upper 16-bit CLA
    cla_16bit cla_high(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S_upper),
        .Cout(C_upper),
        .G_out(G_upper),
        .P_out(P_upper)
    );

    assign S = {S_upper, S_lower};
endmodule