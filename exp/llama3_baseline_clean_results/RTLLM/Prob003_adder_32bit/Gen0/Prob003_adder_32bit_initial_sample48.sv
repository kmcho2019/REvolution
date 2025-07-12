// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input   [3:0] A,
    input   [3:0] B,
    input   Cin,
    output  [3:0] S,
    output  Cout
);

    wire [3:0] P, G;
    wire C1, C2, C3;

    assign P = A ^ B;
    assign G = A & B;

    assign C1 = G[0] | (P[0] & Cin);
    assign C2 = G[1] | (P[1] & (G[0] | (P[0] & Cin)));
    assign C3 = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))));

    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ (G[0] | (P[0] & Cin));
    assign S[2] = P[2] ^ (G[1] | (P[1] & (G[0] | (P[0] & Cin))));
    assign S[3] = P[3] ^ (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin))))));

    assign Cout = C3 | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))))));

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input   [15:0] A,
    input   [15:0] B,
    input   Cin,
    output  [15:0] S,
    output  Cout
);

    wire C1, C2, C3;

    cla_4bit cla_0(
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(C1)
    );

    cla_4bit cla_1(
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C1),
        .S(S[7:4]),
        .Cout(C2)
    );

    cla_4bit cla_2(
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C2),
        .S(S[11:8]),
        .Cout(C3)
    );

    cla_4bit cla_3(
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C3),
        .S(S[15:12]),
        .Cout(Cout)
    );

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input   [31:1] A,
    input   [31:1] B,
    output  [31:1] S,
    output  C32
);

    wire C16;

    cla_16bit cla_0(
        .A(A[15:1]),
        .B(B[15:1]),
        .Cin(1'b0),
        .S(S[15:1]),
        .Cout(C16)
    );

    cla_16bit cla_1(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );

endmodule