// 4-bit CLA block
module cla_4bit(A, B, Cin, S, Cout, G, P);
    input [3:0] A;
    input [3:0] B;
    input Cin;
    output [3:0] S;
    output Cout;
    output [3:0] G;
    output [3:0] P;

    wire [3:0] gi, pi;
    wire [3:0] ci;

    assign gi[0] = A[0] & B[0];
    assign pi[0] = A[0] | B[0];
    assign ci[0] = Cin;

    assign G[0] = gi[0];
    assign P[0] = pi[0];

    assign S[0] = A[0] ^ B[0] ^ Cin;

    assign gi[1] = A[1] & B[1];
    assign pi[1] = A[1] | B[1];
    assign ci[1] = gi[0] | (pi[0] & Cin);

    assign G[1] = gi[1];
    assign P[1] = pi[1];

    assign S[1] = A[1] ^ B[1] ^ ci[1];

    assign gi[2] = A[2] & B[2];
    assign pi[2] = A[2] | B[2];
    assign ci[2] = gi[1] | (pi[1] & ci[1]);

    assign G[2] = gi[2];
    assign P[2] = pi[2];

    assign S[2] = A[2] ^ B[2] ^ ci[2];

    assign gi[3] = A[3] & B[3];
    assign pi[3] = A[3] | B[3];
    assign ci[3] = gi[2] | (pi[2] & ci[2]);

    assign G[3] = gi[3];
    assign P[3] = pi[3];

    assign S[3] = A[3] ^ B[3] ^ ci[3];

    assign Cout = gi[3] | (pi[3] & ci[3]);
endmodule

// 16-bit CLA block
module cla_16bit(A, B, Cin, S, Cout, G, P);
    input [15:0] A;
    input [15:0] B;
    input Cin;
    output [15:0] S;
    output Cout;
    output [15:0] G;
    output [15:0] P;

    wire [3:0] gi0, pi0, gi1, pi1, gi2, pi2, gi3, pi3;
    wire [3:0] s0, s1, s2, s3;
    wire c0, c1, c2, c3;

    cla_4bit cla0(A[3:0], B[3:0], Cin, s0, c0, gi0, pi0);
    cla_4bit cla1(A[7:4], B[7:4], c0, s1, c1, gi1, pi1);
    cla_4bit cla2(A[11:8], B[11:8], c1, s2, c2, gi2, pi2);
    cla_4bit cla3(A[15:12], B[15:12], c2, s3, c3, gi3, pi3);

    assign S[3:0] = s0;
    assign S[7:4] = s1;
    assign S[11:8] = s2;
    assign S[15:12] = s3;

    assign G[3:0] = gi0;
    assign G[7:4] = gi1;
    assign G[11:8] = gi2;
    assign G[15:12] = gi3;

    assign P[3:0] = pi0;
    assign P[7:4] = pi1;
    assign P[11:8] = pi2;
    assign P[15:12] = pi3;

    assign Cout = c3;
endmodule

// 32-bit CLA block
module adder_32bit(A, B, S, C32);
    input [31:1] A;
    input [31:1] B;
    output [31:1] S;
    output C32;

    wire [15:0] s0, s1;
    wire c0;

    cla_16bit cla0(A[15:1], B[15:1], 1'b0, s0, c0, , );
    cla_16bit cla1(A[31:16], B[31:16], c0, s1, C32, , );

    assign S[15:1] = s0;
    assign S[31:16] = s1;
endmodule