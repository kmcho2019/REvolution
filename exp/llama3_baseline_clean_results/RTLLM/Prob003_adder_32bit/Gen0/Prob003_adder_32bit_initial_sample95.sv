// 4-bit Carry-Lookahead Adder
module cla_4bit(A, B, Cin, S, Cout, G, P);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;
    output [3:0] G, P;

    assign G[0] = A[0] & B[0];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];

    assign P[0] = A[0] | B[0];
    assign P[1] = A[1] | B[1];
    assign P[2] = A[2] | B[2];
    assign P[3] = A[3] | B[3];

    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ (G[0] | (P[0] & Cin));
    assign S[2] = A[2] ^ B[2] ^ (G[1] | (P[1] & (G[0] | (P[0] & Cin))));
    assign S[3] = A[3] ^ B[3] ^ (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))));

    assign Cout = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))));
endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(A, B, Cin, S, Cout, G, P);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;
    output [15:0] G, P;

    wire [3:0] G_4bit;
    wire [3:0] P_4bit;
    wire C4, C8, C12;

    cla_4bit cla_0(A[3:0], B[3:0], Cin, S[3:0], C4, G_4bit, P_4bit);
    assign G[3:0] = G_4bit;
    assign P[3:0] = P_4bit;

    cla_4bit cla_4(A[7:4], B[7:4], C4, S[7:4], C8, G_4bit, P_4bit);
    assign G[7:4] = G_4bit;
    assign P[7:4] = P_4bit;

    cla_4bit cla_8(A[11:8], B[11:8], C8, S[11:8], C12, G_4bit, P_4bit);
    assign G[11:8] = G_4bit;
    assign P[11:8] = P_4bit;

    cla_4bit cla_12(A[15:12], B[15:12], C12, S[15:12], Cout, G_4bit, P_4bit);
    assign G[15:12] = G_4bit;
    assign P[15:12] = P_4bit;
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(A, B, S, C32);
    input [31:0] A, B;
    output [31:0] S;
    output C32;

    wire C16;

    cla_16bit cla_0(A[15:0], B[15:0], 1'b0, S[15:0], C16, , );
    cla_16bit cla_16(A[31:16], B[31:16], C16, S[31:16], C32, , );
endmodule