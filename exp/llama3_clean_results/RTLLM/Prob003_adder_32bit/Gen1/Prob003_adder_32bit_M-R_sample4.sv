// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout,
    output [4:1] P,
    output [4:1] G
);
    wire [4:1] c;
    assign c[1] = Cin;
    assign S[1] = A[1] ^ B[1] ^ c[1];
    assign c[2] = (A[1] & B[1]) | (A[1] & c[1]) | (B[1] & c[1]);
    assign S[2] = A[2] ^ B[2] ^ c[2];
    assign c[3] = (A[2] & B[2]) | (A[2] & c[2]) | (B[2] & c[2]);
    assign S[3] = A[3] ^ B[3] ^ c[3];
    assign c[4] = (A[3] & B[3]) | (A[3] & c[3]) | (B[3] & c[3]);
    assign S[4] = A[4] ^ B[4] ^ c[4];
    assign Cout = c[4];
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
    input Cin,
    output [16:1] S,
    output Cout
);
    wire C1, C2, C3;
    cla_4bit cla1(
      .A(A[4:1]),
      .B(B[4:1]),
      .Cin(Cin),
      .S(S[4:1]),
      .Cout(C1),
      .P(),
      .G()
    );
    cla_4bit cla2(
      .A(A[8:5]),
      .B(B[8:5]),
      .Cin(C1),
      .S(S[8:5]),
      .Cout(C2),
      .P(),
      .G()
    );
    cla_4bit cla3(
      .A(A[12:9]),
      .B(B[12:9]),
      .Cin(C2),
      .S(S[12:9]),
      .Cout(C3),
      .P(),
      .G()
    );
    cla_4bit cla4(
      .A(A[16:13]),
      .B(B[16:13]),
      .Cin(C3),
      .S(S[16:13]),
      .Cout(Cout),
      .P(),
      .G()
    );
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
      .Cin(0),
      .S(S[16:1]),
      .Cout(C16)
    );
    cla_16bit cla2(
      .A(A[32:17]),
      .B(B[32:17]),
      .Cin(C16),
      .S(S[32:17]),
      .Cout(C32)
    );
endmodule