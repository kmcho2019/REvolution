module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout,
    output        P,  // block propagate
    output        G   // block generate
);
    wire [16:1] p; // bit propagate
    wire [16:1] g; // bit generate

    // Generate bit propagate and generate signals
    assign p = A ^ B;
    assign g = A & B;

    // Define group propagate and generate signals for 4-bit groups
    wire [4:1] P_group;
    wire [4:1] G_group;

    // Group 1: bits 1 to 4
    assign P_group[1] = &p[4:1];
    assign G_group[1] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]);

    // Group 2: bits 5 to 8
    assign P_group[2] = &p[8:5];
    assign G_group[2] = g[8] | (p[8] & g[7]) | (p[8] & p[7] & g[6]) | (p[8] & p[7] & p[6] & g[5]);

    // Group 3: bits 9 to 12
    assign P_group[3] = &p[12:9];
    assign G_group[3] = g[12] | (p[12] & g[11]) | (p[12] & p[11] & g[10]) | (p[12] & p[11] & p[10] & g[9]);

    // Group 4: bits 13 to 16
    assign P_group[4] = &p[16:13];
    assign G_group[4] = g[16] | (p[16] & g[15]) | (p[16] & p[15] & g[14]) | (p[16] & p[15] & p[14] & g[13]);

    // Compute carries at group boundaries
    wire c1, c2, c3, c4;
    assign c1 = G_group[1] | (P_group[1] & Cin);
    assign c2 = G_group[2] | (P_group[2] & c1);
    assign c3 = G_group[3] | (P_group[3] & c2);
    assign c4 = G_group[4] | (P_group[4] & c3);
    assign Cout = c4;

    // Compute carries within groups
    // For bits 1-4
    wire c_0 = Cin;
    wire c_1 = g[1] | (p[1] & c_0);
    wire c_2 = g[2] | (p[2] & c_1);
    wire c_3 = g[3] | (p[3] & c_2);
    wire c_4 = g[4] | (p[4] & c_3);

    // For bits 5-8
    wire c_5 = g[5] | (p[5] & c_4);
    wire c_6 = g[6] | (p[6] & c_5);
    wire c_7 = g[7] | (p[7] & c_6);
    wire c_8 = g[8] | (p[8] & c_7);

    // For bits 9-12
    wire c_9  = g[9]  | (p[9]  & c_8);
    wire c_10 = g[10] | (p[10] & c_9);
    wire c_11 = g[11] | (p[11] & c_10);
    wire c_12 = g[12] | (p[12] & c_11);

    // For bits 13-16
    wire c_13 = g[13] | (p[13] & c_12);
    wire c_14 = g[14] | (p[14] & c_13);
    wire c_15 = g[15] | (p[15] & c_14);
    wire c_16 = g[16] | (p[16] & c_15);

    // Sum bits
    assign S[1]  = p[1]  ^ c_0;
    assign S[2]  = p[2]  ^ c_1;
    assign S[3]  = p[3]  ^ c_2;
    assign S[4]  = p[4]  ^ c_3;

    assign S[5]  = p[5]  ^ c_4;
    assign S[6]  = p[6]  ^ c_5;
    assign S[7]  = p[7]  ^ c_6;
    assign S[8]  = p[8]  ^ c_7;

    assign S[9]  = p[9]  ^ c_8;
    assign S[10] = p[10] ^ c_9;
    assign S[11] = p[11] ^ c_10;
    assign S[12] = p[12] ^ c_11;

    assign S[13] = p[13] ^ c_12;
    assign S[14] = p[14] ^ c_13;
    assign S[15] = p[15] ^ c_14;
    assign S[16] = p[16] ^ c_15;

    // Block propagate and generate signals
    assign P = &p;
    assign G = G_group[4] | (P_group[4] & G_group[3]) | (P_group[4] & P_group[3] & G_group[2]) | (P_group[4] & P_group[3] & P_group[2] & G_group[1]);
endmodule


module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire P0, G0;    // Propagate and generate of lower 16-bit block
    wire P1, G1;    // Propagate and generate of upper 16-bit block
    wire C16;       // Carry out of lower 16-bit block (carry into upper)

    // Lower 16-bit CLA (bits 1 to 16), carry in = 0
    cla_16bit cla_lo(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16),
        .P(P0),
        .G(G0)
    );

    // Carry-in to upper 16-bit block = G0 + P0 * 0 = G0
    wire Cin_hi = G0;

    // Upper 16-bit CLA (bits 17 to 32)
    cla_16bit cla_hi(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cin_hi),
        .S(S[32:17]),
        .Cout(C32),
        .P(P1),
        .G(G1)
    );
endmodule