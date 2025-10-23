// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        C0,
    output [4:1] S,
    output       C4
);

    wire [3:1] G;  // Generate
    wire [3:1] P;  // Propagate
    wire [3:1] C;  // Carry

    // Calculate Generate and Propagate signals
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] ^ B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] ^ B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] ^ B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] ^ B[4];

    // Calculate Carry signals
    assign C[1] = G[1] | (P[1] & C0);
    assign C[2] = G[2] | (P[2] & (G[1] | (P[1] & C0)));
    assign C[3] = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & C0)))));
    assign C[4] = G[4] | (P[4] & (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & C0)))))));

    // Calculate Sum signals
    assign S[1] = P[1] ^ C0;
    assign S[2] = P[2] ^ (G[1] | (P[1] & C0));
    assign S[3] = P[3] ^ (G[2] | (P[2] & (G[1] | (P[1] & C0))));
    assign S[4] = P[4] ^ (G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & C0))))));

    assign C4 = C[4];

endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         C0,
    output [16:1] S,
    output        C16
);

    wire        C4, C8, C12;
    wire [4:1]  A1, A2, A3, A4;
    wire [4:1]  B1, B2, B3, B4;
    wire [4:1]  S1, S2, S3, S4;

    assign A1 = A[4:1];
    assign A2 = A[8:5];
    assign A3 = A[12:9];
    assign A4 = A[16:13];

    assign B1 = B[4:1];
    assign B2 = B[8:5];
    assign B3 = B[12:9];
    assign B4 = B[16:13];

    cla_4bit u1(A1, B1, C0, S1, C4);
    cla_4bit u2(A2, B2, C4, S2, C8);
    cla_4bit u3(A3, B3, C8, S3, C12);
    cla_4bit u4(A4, B4, C12, S4, C16);

    assign S[4:1]  = S1;
    assign S[8:5]  = S2;
    assign S[12:9] = S3;
    assign S[16:13] = S4;

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);

    wire C16;
    wire [16:1] A1, A2;
    wire [16:1] B1, B2;
    wire [16:1] S1, S2;

    assign A1 = A[16:1];
    assign A2 = A[32:17];

    assign B1 = B[16:1];
    assign B2 = B[32:17];

    cla_16bit u1(A1, B1, 1'b0, S1, C16);
    cla_16bit u2(A2, B2, C16, S2, C32);

    assign S[16:1]  = S1;
    assign S[32:17] = S2;

endmodule