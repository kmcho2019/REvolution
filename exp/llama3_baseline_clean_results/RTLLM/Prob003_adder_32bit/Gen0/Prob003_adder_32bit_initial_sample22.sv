// 4-bit CLA module
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input       C0,
    output [4:1] S,
    output      C4,
    output [4:1] G,
    output [4:1] P
);

    wire [4:1] gi, pi;

    assign gi[1] = A[1] & B[1];
    assign pi[1] = A[1] | B[1];
    assign S[1]  = A[1] ^ B[1] ^ C0;

    assign gi[2] = A[2] & B[2];
    assign pi[2] = A[2] | B[2];
    assign S[2]  = A[2] ^ B[2] ^ (C0 & pi[1]);

    assign gi[3] = A[3] & B[3];
    assign pi[3] = A[3] | B[3];
    assign S[3]  = A[3] ^ B[3] ^ (C0 & pi[1] & pi[2]);

    assign gi[4] = A[4] & B[4];
    assign pi[4] = A[4] | B[4];
    assign S[4]  = A[4] ^ B[4] ^ (C0 & pi[1] & pi[2] & pi[3]);
    assign C4    = (gi[1] | (pi[1] & gi[2]) | (pi[1] & pi[2] & gi[3]) | (pi[1] & pi[2] & pi[3] & gi[4]));

    assign G = gi;
    assign P = pi;

endmodule

// 16-bit CLA module
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input       C0,
    output [16:1] S,
    output      C16,
    output [4:1] G,
    output [4:1] P
);

    wire [4:1] g1, p1, g2, p2, g3, p3, g4, p4;
    wire       c4, c8, c12;

    cla_4bit cla1(A[4:1], B[4:1], C0, S[4:1], c4, g1, p1);
    cla_4bit cla2(A[8:5], B[8:5], c4, S[8:5], c8, g2, p2);
    cla_4bit cla3(A[12:9], B[12:9], c8, S[12:9], c12, g3, p3);
    cla_4bit cla4(A[16:13], B[16:13], c12, S[16:13], C16, g4, p4);

    assign G = {g4, g3, g2, g1};
    assign P = {p4, p3, p2, p1};

endmodule

// 32-bit CLA module
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output      C32
);

    wire       c16;
    wire [4:1] g1, p1, g2, p2;

    cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], c16, g1, p1);
    cla_16bit cla2(A[32:17], B[32:17], c16, S[32:17], C32, g2, p2);

endmodule