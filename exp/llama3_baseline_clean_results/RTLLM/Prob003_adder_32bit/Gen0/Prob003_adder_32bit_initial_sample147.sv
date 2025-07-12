// 1-bit full adder
module full_adder(A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;
    wire [3:0] G, P;
    assign G = A & B;
    assign P = A | B;
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign Cout = G[0] | (P[0] & Cin);
    assign S[1] = A[1] ^ B[1] ^ (G[0] | (P[0] & Cin));
    assign S[2] = A[2] ^ B[2] ^ (G[1] | (P[1] & (G[0] | (P[0] & Cin))));
    assign S[3] = A[3] ^ B[3] ^ (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))));
    assign Cout = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))));
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(A, B, Cin, S, Cout);
    input [15:0] A, B;
    input Cin;
    output [15:0] S;
    output Cout;
    wire Cout_4, Cout_8, Cout_12;
    cla_4bit u1(A[3:0], B[3:0], Cin, S[3:0], Cout_4);
    cla_4bit u2(A[7:4], B[7:4], Cout_4, S[7:4], Cout_8);
    cla_4bit u3(A[11:8], B[11:8], Cout_8, S[11:8], Cout_12);
    cla_4bit u4(A[15:12], B[15:12], Cout_12, S[15:12], Cout);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(A, B, S, C32);
    input [31:1] A, B;
    output [31:1] S;
    output C32;
    wire C16;
    cla_16bit u1(A[15:1], B[15:1], 1'b0, S[15:1], C16);
    cla_16bit u2(A[31:16], B[31:16], C16, S[31:16], C32);
endmodule