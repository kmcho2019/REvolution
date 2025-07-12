// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [16:1] c;
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
    assign c[9] = (A[8] & B[8]) | (A[8] & c[8]) | (B[8] & c[8]);
    assign S[9] = A[9] ^ B[9] ^ c[9];
    assign c[10] = (A[9] & B[9]) | (A[9] & c[9]) | (B[9] & c[9]);
    assign S[10] = A[10] ^ B[10] ^ c[10];
    assign c[11] = (A[10] & B[10]) | (A[10] & c[10]) | (B[10] & c[10]);
    assign S[11] = A[11] ^ B[11] ^ c[11];
    assign c[12] = (A[11] & B[11]) | (A[11] & c[11]) | (B[11] & c[11]);
    assign S[12] = A[12] ^ B[12] ^ c[12];
    assign c[13] = (A[12] & B[12]) | (A[12] & c[12]) | (B[12] & c[12]);
    assign S[13] = A[13] ^ B[13] ^ c[13];
    assign c[14] = (A[13] & B[13]) | (A[13] & c[13]) | (B[13] & c[13]);
    assign S[14] = A[14] ^ B[14] ^ c[14];
    assign c[15] = (A[14] & B[14]) | (A[14] & c[14]) | (B[14] & c[14]);
    assign S[15] = A[15] ^ B[15] ^ c[15];
    assign c[16] = (A[15] & B[15]) | (A[15] & c[15]) | (B[15] & c[15]);
    assign S[16] = A[16] ^ B[16] ^ c[16];
    assign Cout = (A[16] & B[16]) | (A[16] & c[16]) | (B[16] & c[16]);
endmodule

// 32-bit Carry-Lookahead Adder using 16-bit CLA blocks
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
     .Cin(1'b0),
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