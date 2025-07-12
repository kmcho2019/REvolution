// 4-bit Carry-Lookahead Adder
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

    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ (G[0] | (P[0] & Cin));
    assign S[2] = A[2] ^ B[2] ^ (G[1] | (P[1] & (G[0] | (P[0] & Cin))));
    assign S[3] = A[3] ^ B[3] ^ (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))));

    assign Cout = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))));

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input  Cin,
    output [15:0] S,
    output Cout
);

    wire C4, C8, C12;

    cla_4bit cla0(
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(C4)
    );

    cla_4bit cla1(
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C4),
        .S(S[7:4]),
        .Cout(C8)
    );

    cla_4bit cla2(
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C8),
        .S(S[11:8]),
        .Cout(C12)
    );

    cla_4bit cla3(
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C12),
        .S(S[15:12]),
        .Cout(Cout)
    );

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input  [31:1] A,
    input  [31:1] B,
    output [31:1] S,
    output C32
);

    wire C16;

    cla_16bit cla0(
        .A(A[15:1]),
        .B(B[15:1]),
        .Cin(1'b0),
        .S(S[15:1]),
        .Cout(C16)
    );

    cla_16bit cla1(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );

endmodule