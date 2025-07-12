module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       Pout,  // block propagate
    output       Gout   // block generate
);
    wire [4:1] P, G;
    wire [4:0] C;

    assign C[0] = Cin;

    // Generate and propagate signals for each bit
    assign P = A ^ B;
    assign G = A & B;

    // Carry for each bit within 4-bit block
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[0]);

    // Sum calculation
    assign S = P ^ C[3:0];

    // Block propagate is AND of all propagates
    assign Pout = &P;

    // Block generate using carry-out minus Cin part:
    // Gout = G[4] + P[4]*G[3] + P[4]*P[3]*G[2] + P[4]*P[3]*P[2]*G[1]
    //       + P[4]*P[3]*P[2]*P[1]*Cin, but for group generate (no Cin)
    assign Gout = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);

    assign Cout = C[4];
endmodule


module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        Pout,
    output        Gout
);
    // Break 16 bits into 4 groups of 4 bits
    wire [4:1] S0, S1, S2, S3;
    wire C1, C2, C3, C4;
    wire P0, G0, P1, G1, P2, G2, P3, G3;

    // Instantiate 4-bit CLAs for each 4-bit block
    cla_4bit cla0(
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(Cin),
        .S(S0),
        .Cout(C1),
        .Pout(P0),
        .Gout(G0)
    );

    cla_4bit cla1(
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(C1),
        .S(S1),
        .Cout(C2),
        .Pout(P1),
        .Gout(G1)
    );

    cla_4bit cla2(
        .A(A[12:9]),
        .B(B[12:9]),
        .Cin(C2),
        .S(S2),
        .Cout(C3),
        .Pout(P2),
        .Gout(G2)
    );

    cla_4bit cla3(
        .A(A[16:13]),
        .B(B[16:13]),
        .Cin(C3),
        .S(S3),
        .Cout(C4),
        .Pout(P3),
        .Gout(G3)
    );

    // Top-level carry lookahead for the 4 blocks
    // Carries into each block:
    // C1 = G0 + P0*Cin
    // C2 = G1 + P1*G0 + P1*P0*Cin
    // C3 = G2 + P2*G1 + P2*P1*G0 + P2*P1*P0*Cin
    // C4 = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0 + P3*P2*P1*P0*Cin

    wire c1, c2, c3, c4;

    assign c1 = G0 | (P0 & Cin);
    assign c2 = G1 | (P1 & G0) | (P1 & P0 & Cin);
    assign c3 = G2 | (P2 & G1) | (P2 & P1 & G0) | (P2 & P1 & P0 & Cin);
    assign c4 = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0) | (P3 & P2 & P1 & P0 & Cin);

    // Connect internal carries to the cla_4bit blocks
    // Overwrite the Cins for cla1, cla2, cla3 blocks to match calculated carries
    // The instantiated cla_4bit modules used C1, C2, C3 for carries (outputs),
    // but we must override the carries used as inputs to these blocks to c1, c2, c3 respectively.

    // We achieve this by instantiating 4-bit blocks first without Cin,
    // then using combinational logic for sum calculation with these carries.
    // However, simpler approach: recalc sum bits here from propagate and carry signals.

    // Instead of overriding instantiated carries, better to do sum calculations here:

    // Redefine P and G for each bit for sum calculation
    wire [16:1] P_bit = A ^ B;
    wire [16:1] G_bit = A & B;

    wire [16:0] C_bit;
    assign C_bit[0] = Cin;
    assign C_bit[4]  = c1;
    assign C_bit[8]  = c2;
    assign C_bit[12] = c3;
    assign C_bit[16] = c4;

    // Calculate intermediate carries inside each 4-bit block similarly:

    // For bits 1 to 4:
    assign C_bit[1] = G_bit[1]  | (P_bit[1]  & C_bit[0]);
    assign C_bit[2] = G_bit[2]  | (P_bit[2]  & G_bit[1])  | (P_bit[2]  & P_bit[1]  & C_bit[0]);
    assign C_bit[3] = G_bit[3]  | (P_bit[3]  & G_bit[2])  | (P_bit[3]  & P_bit[2]  & G_bit[1])  | (P_bit[3]  & P_bit[2]  & P_bit[1]  & C_bit[0]);
    // C_bit[4] is c1 assigned above

    // For bits 5 to 8:
    assign C_bit[5] = G_bit[5]  | (P_bit[5]  & C_bit[4]);
    assign C_bit[6] = G_bit[6]  | (P_bit[6]  & G_bit[5])  | (P_bit[6]  & P_bit[5]  & C_bit[4]);
    assign C_bit[7] = G_bit[7]  | (P_bit[7]  & G_bit[6])  | (P_bit[7]  & P_bit[6]  & G_bit[5])  | (P_bit[7]  & P_bit[6]  & P_bit[5]  & C_bit[4]);
    // C_bit[8] is c2 assigned above

    // For bits 9 to 12:
    assign C_bit[9]  = G_bit[9]  | (P_bit[9]  & C_bit[8]);
    assign C_bit[10] = G_bit[10] | (P_bit[10] & G_bit[9])  | (P_bit[10] & P_bit[9]  & C_bit[8]);
    assign C_bit[11] = G_bit[11] | (P_bit[11] & G_bit[10]) | (P_bit[11] & P_bit[10] & G_bit[9])  | (P_bit[11] & P_bit[10] & P_bit[9]  & C_bit[8]);
    // C_bit[12] is c3 assigned above

    // For bits 13 to 16:
    assign C_bit[13] = G_bit[13] | (P_bit[13] & C_bit[12]);
    assign C_bit[14] = G_bit[14] | (P_bit[14] & G_bit[13]) | (P_bit[14] & P_bit[13] & C_bit[12]);
    assign C_bit[15] = G_bit[15] | (P_bit[15] & G_bit[14]) | (P_bit[15] & P_bit[14] & G_bit[13]) | (P_bit[15] & P_bit[14] & P_bit[13] & C_bit[12]);
    // C_bit[16] is c4 assigned above

    // Sum bits
    assign S = P_bit ^ C_bit[15:0];

    assign Cout = C_bit[16];

    // Group propagate is AND of 4 block propagates
    assign Pout = P0 & P1 & P2 & P3;

    // Group generate using 4-block hierarchy:
    assign Gout = G3 | (P3 & G2) | (P3 & P2 & G1) | (P3 & P2 & P1 & G0);

endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;
    wire P_low, G_low;
    wire P_high, G_high;

    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .Pout(P_low),
        .Gout(G_low)
    );

    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32),
        .Pout(P_high),
        .Gout(G_high)
    );

endmodule