// 4-bit CLA module
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input  C_in,
    output [4:1] S,
    output C_out,
    output G,
    output P
);

    wire [4:1] G_i;
    wire [4:1] P_i;
    wire [4:1] C_i;

    // generate and propagate signals
    assign G_i[1] = A[1] & B[1];
    assign P_i[1] = A[1] | B[1];

    assign G_i[2] = A[2] & B[2];
    assign P_i[2] = A[2] | B[2];

    assign G_i[3] = A[3] & B[3];
    assign P_i[3] = A[3] | B[3];

    assign G_i[4] = A[4] & B[4];
    assign P_i[4] = A[4] | B[4];

    // calculate carry signals
    assign C_i[1] = C_in;
    assign C_i[2] = G_i[1] | (P_i[1] & C_i[1]);
    assign C_i[3] = G_i[2] | (P_i[2] & C_i[2]);
    assign C_i[4] = G_i[3] | (P_i[3] & C_i[3]);

    // calculate sum signals
    assign S[1] = A[1] ^ B[1] ^ C_i[1];
    assign S[2] = A[2] ^ B[2] ^ C_i[2];
    assign S[3] = A[3] ^ B[3] ^ C_i[3];
    assign S[4] = A[4] ^ B[4] ^ C_i[4];

    // calculate carry out, generate and propagate
    assign C_out = G_i[4] | (P_i[4] & C_i[4]);
    assign G = G_i[4];
    assign P = P_i[4];

endmodule

// 16-bit CLA module
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input  C_in,
    output [16:1] S,
    output C_out
);

    wire [4:1] C_i;
    wire [4:1] G_i;
    wire [4:1] P_i;

    // 4-bit CLA modules
    cla_4bit cla1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S[4:1]),
        .C_out(C_i[1]),
        .G(G_i[1]),
        .P(P_i[1])
    );

    cla_4bit cla2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C_i[1]),
        .S(S[8:5]),
        .C_out(C_i[2]),
        .G(G_i[2]),
        .P(P_i[2])
    );

    cla_4bit cla3(
        .A(A[12:9]),
        .B(B[12:9]),
        .C_in(C_i[2]),
        .S(S[12:9]),
        .C_out(C_i[3]),
        .G(G_i[3]),
        .P(P_i[3])
    );

    cla_4bit cla4(
        .A(A[16:13]),
        .B(B[16:13]),
        .C_in(C_i[3]),
        .S(S[16:13]),
        .C_out(C_out),
        .G(),
        .P()
    );

endmodule

// 32-bit adder module
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output C32
);

    wire C16;

    // 16-bit CLA modules
    cla_16bit cla1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla_16bit cla2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule