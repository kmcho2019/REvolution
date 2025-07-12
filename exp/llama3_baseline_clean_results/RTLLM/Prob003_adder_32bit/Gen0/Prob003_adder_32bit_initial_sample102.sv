// 4-bit Carry-Lookahead Adder (CLA) module
module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input  Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G, P;
    assign G = A & B;
    assign P = A | B;

    wire G1, P1, G2, P2, G3, P3;
    assign G1 = G[0];
    assign P1 = P[0];
    assign G2 = G[1] | (P[1] & G1);
    assign P2 = P[1] & P1;
    assign G3 = G[2] | (P[2] & G2);
    assign P3 = P[2] & P2;

    assign Cout = G3 | (P3 & Cin);
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ (G1 | (P1 & Cin));
    assign S[2] = A[2] ^ B[2] ^ (G2 | (P2 & Cin));
    assign S[3] = A[3] ^ B[3] ^ (G3 | (P3 & Cin));
endmodule

// 16-bit Carry-Lookahead Adder (CLA) module
module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input  Cin,
    output [15:0] S,
    output Cout
);
    wire C1, C2, C3;
    cla_4bit cla1(A[3:0], B[3:0], Cin, S[3:0], C1);
    cla_4bit cla2(A[7:4], B[7:4], C1, S[7:4], C2);
    cla_4bit cla3(A[11:8], B[11:8], C2, S[11:8], C3);
    cla_4bit cla4(A[15:12], B[15:12], C3, S[15:12], Cout);
endmodule

// 32-bit Carry-Lookahead Adder (CLA) module
module adder_32bit(
    input  [31:1] A,
    input  [31:1] B,
    output [31:1] S,
    output C32
);
    wire C16;
    cla_16bit cla1(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit cla2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule