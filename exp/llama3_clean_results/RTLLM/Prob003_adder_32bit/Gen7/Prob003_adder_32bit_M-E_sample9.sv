// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input Cin,
    output [8:1] S,
    output Cout
);
    wire [8:1] c;
    assign c[1] = Cin;
    assign S[1] = A[1] ^ B[1] ^ c[1];
    assign c[2] = (A[1] & B[1]) | (A[1] & c[1]) | (B[1] & c[1]);
    assign S[2] = A[2] ^ B[2] ^ c[2];
    assign c[3] = (A[2] & B[2]) | (A[2] & c[2]) | (B[2] & c[2]);
    assign S[3] = A[3] ^ B[3] ^ c[3];
    assign c[4] = (A[3] & B[3]) | (A[3] & c[3]) | (B[3] & c[3]);
    assign S[4] = A[4] ^ B[4] ^ c[4];
    assign c[5] = (A[4] & B[4]) | (A[4] & c[4]) | (B[4] & c[4]);
    assign S[5] = A[5] ^ B[5] ^ c[5];
    assign c[6] = (A[5] & B[5]) | (A[5] & c[5]) | (B[5] & c[5]);
    assign S[6] = A[6] ^ B[6] ^ c[6];
    assign c[7] = (A[6] & B[6]) | (A[6] & c[6]) | (B[6] & c[6]);
    assign S[7] = A[7] ^ B[7] ^ c[7];
    assign c[8] = (A[7] & B[7]) | (A[7] & c[7]) | (B[7] & c[7]);
    assign S[8] = A[8] ^ B[8] ^ c[8];
    assign Cout = (A[8] & B[8]) | (A[8] & c[8]) | (B[8] & c[8]);
endmodule

// 32-bit Hierarchical Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C8, C16, C24;
    cla_8bit cla1(
    .A(A[8:1]),
    .B(B[8:1]),
    .Cin(1'b0),
    .S(S[8:1]),
    .Cout(C8)
    );
    cla_8bit cla2(
    .A(A[16:9]),
    .B(B[16:9]),
    .Cin(C8),
    .S(S[16:9]),
    .Cout(C16)
    );
    cla_8bit cla3(
    .A(A[24:17]),
    .B(B[24:17]),
    .Cin(C16),
    .S(S[24:17]),
    .Cout(C24)
    );
    cla_8bit cla4(
    .A(A[32:25]),
    .B(B[32:25]),
    .Cin(C24),
    .S(S[32:25]),
    .Cout(C32)
    );
endmodule