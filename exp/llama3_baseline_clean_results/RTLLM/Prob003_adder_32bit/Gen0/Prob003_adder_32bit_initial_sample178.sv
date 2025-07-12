// 4-bit carry-lookahead adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    output [4:1] S,
    output C4
);
    wire [3:1] G;  // Generate signals
    wire [3:1] P;  // Propagate signals
    wire [3:1] C;  // Carry signals

    // Generate and propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] | B[4];

    // Calculate carry signals
    assign C[1] = G[1];
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    // Calculate sum signals
    assign S[1] = A[1] ^ B[1] ^ C[1];
    assign S[2] = A[2] ^ B[2] ^ C[2];
    assign S[3] = A[3] ^ B[3] ^ C[3];
    assign S[4] = A[4] ^ B[4] ^ C[4];

    // Carry-out
    assign C4 = C[4];

endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    output [16:1] S,
    output C16
);
    wire C4_1, C4_2, C4_3, C4_4;  // Carry signals

    // 4-bit blocks
    cla_4bit block1(
        .A(A[4:1]),
        .B(B[4:1]),
        .S(S[4:1]),
        .C4(C4_1)
    );

    cla_4bit block2(
        .A(A[8:5]),
        .B(B[8:5]),
        .S(S[8:5]),
        .C4(C4_2)
    );

    cla_4bit block3(
        .A(A[12:9]),
        .B(B[12:9]),
        .S(S[12:9]),
        .C4(C4_3)
    );

    cla_4bit block4(
        .A(A[16:13]),
        .B(B[16:13]),
        .S(S[16:13]),
        .C4(C4_4)
    );

    // Carry signals
    assign C16 = C4_4;

endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16_1, C16_2;  // Carry signals

    // 16-bit blocks
    cla_16bit block1(
        .A(A[16:1]),
        .B(B[16:1]),
        .S(S[16:1]),
        .C16(C16_1)
    );

    cla_16bit block2(
        .A(A[32:17]),
        .B(B[32:17]),
        .S(S[32:17]),
        .C16(C16_2)
    );

    // Carry-out
    assign C32 = C16_2;

endmodule