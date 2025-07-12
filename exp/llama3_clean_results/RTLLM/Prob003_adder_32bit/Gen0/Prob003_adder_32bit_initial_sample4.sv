// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    output [4:1] S,
    output C_out,
    output [4:1] P,
    output [4:1] G
);
    wire [3:0] c;
    assign c[0] = 0;
    assign S[1] = A[1] ^ B[1] ^ c[0];
    assign c[1] = (A[1] & B[1]) | (A[1] & c[0]) | (B[1] & c[0]);
    assign S[2] = A[2] ^ B[2] ^ c[1];
    assign c[2] = (A[2] & B[2]) | (A[2] & c[1]) | (B[2] & c[1]);
    assign S[3] = A[3] ^ B[3] ^ c[2];
    assign c[3] = (A[3] & B[3]) | (A[3] & c[2]) | (B[3] & c[2]);
    assign S[4] = A[4] ^ B[4] ^ c[3];
    assign C_out = c[3];
    assign P[1] = A[1] ^ B[1];
    assign P[2] = A[2] ^ B[2];
    assign P[3] = A[3] ^ B[3];
    assign P[4] = A[4] ^ B[4];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];
    assign G[4] = A[4] & B[4];
endmodule

// 16-bit Carry-Lookahead Adder using 4-bit CLA blocks
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    output [16:1] S,
    output C_out,
    output C_in
);
    wire [4:1] P1, P2, P3, P4;
    wire [4:1] G1, G2, G3, G4;
    wire C1, C2, C3;
    cla_4bit cla1(
       .A(A[4:1]),
       .B(B[4:1]),
       .S(S[4:1]),
       .C_out(C1),
       .P(P1),
       .G(G1)
    );
    cla_4bit cla2(
       .A(A[8:5]),
       .B(B[8:5]),
       .S(S[8:5]),
       .C_out(C2),
       .P(P2),
       .G(G2)
    );
    cla_4bit cla3(
       .A(A[12:9]),
       .B(B[12:9]),
       .S(S[12:9]),
       .C_out(C3),
       .P(P3),
       .G(G3)
    );
    cla_4bit cla4(
       .A(A[16:13]),
       .B(B[16:13]),
       .S(S[16:13]),
       .C_out(C_out),
       .P(P4),
       .G(G4)
    );
    assign C_in = C1;
    // Compute the carry-in for each 4-bit block using the propagate and generate signals
    // For cla2
    assign S[5] = A[5] ^ B[5] ^ (P1[4] & G1[4]) | (P1[4] & C1);
    assign S[6] = A[6] ^ B[6] ^ (P1[4] & G1[4]) | (P1[4] & C1);
    assign S[7] = A[7] ^ B[7] ^ (P1[4] & G1[4]) | (P1[4] & C1);
    assign S[8] = A[8] ^ B[8] ^ (P1[4] & G1[4]) | (P1[4] & C1);
    // For cla3
    assign S[9] = A[9] ^ B[9] ^ (P2[4] & G2[4]) | (P2[4] & C2);
    assign S[10] = A[10] ^ B[10] ^ (P2[4] & G2[4]) | (P2[4] & C2);
    assign S[11] = A[11] ^ B[11] ^ (P2[4] & G2[4]) | (P2[4] & C2);
    assign S[12] = A[12] ^ B[12] ^ (P2[4] & G2[4]) | (P2[4] & C2);
    // For cla4
    assign S[13] = A[13] ^ B[13] ^ (P3[4] & G3[4]) | (P3[4] & C3);
    assign S[14] = A[14] ^ B[14] ^ (P3[4] & G3[4]) | (P3[4] & C3);
    assign S[15] = A[15] ^ B[15] ^ (P3[4] & G3[4]) | (P3[4] & C3);
    assign S[16] = A[16] ^ B[16] ^ (P3[4] & G3[4]) | (P3[4] & C3);
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    cla_16bit cla1(
       .A(A[16:1]),
       .B(B[16:1]),
       .S(S[16:1]),
       .C_out(C16),
       .C_in(0)
    );
    cla_16bit cla2(
       .A(A[32:17]),
       .B(B[32:17]),
       .S(S[32:17]),
       .C_out(C32),
       .C_in(C16)
    );
endmodule