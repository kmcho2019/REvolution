// 4-bit carry-lookahead adder module
module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input       C0,
    output [4:1] S,
    output       C4
);

    wire [4:1] P, G;
    wire [4:1] C;

    // Compute carry propagate (P) and carry generate (G) signals
    assign P = A ^ B;
    assign G = A & B;

    // Compute carry-out (C) signals
    assign C[1] = G[1] + (P[1] & C0);
    assign C[2] = G[2] + (P[2] & C[1]);
    assign C[3] = G[3] + (P[3] & C[2]);
    assign C[4] = G[4] + (P[4] & C[3]);

    // Compute sum (S) signals
    assign S[1] = A[1] ^ B[1] ^ C0;
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign S[4] = A[4] ^ B[4] ^ C[3];

    assign C4 = C[4];

endmodule

// 16-bit carry-lookahead adder module
module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input       C0,
    output [16:1] S,
    output       C16
);

    wire [16:1] P, G;
    wire [16:1] C;

    // Compute carry propagate (P) and carry generate (G) signals
    assign P = A ^ B;
    assign G = A & B;

    // Compute carry-out (C) signals
    assign C[1] = G[1] + (P[1] & C0);
    assign C[2] = G[2] + (P[2] & C[1]);
    assign C[3] = G[3] + (P[3] & C[2]);
    assign C[4] = G[4] + (P[4] & C[3]);
    assign C[5] = G[5] + (P[5] & C[4]);
    assign C[6] = G[6] + (P[6] & C[5]);
    assign C[7] = G[7] + (P[7] & C[6]);
    assign C[8] = G[8] + (P[8] & C[7]);
    assign C[9] = G[9] + (P[9] & C[8]);
    assign C[10] = G[10] + (P[10] & C[9]);
    assign C[11] = G[11] + (P[11] & C[10]);
    assign C[12] = G[12] + (P[12] & C[11]);
    assign C[13] = G[13] + (P[13] & C[12]);
    assign C[14] = G[14] + (P[14] & C[13]);
    assign C[15] = G[15] + (P[15] & C[14]);
    assign C[16] = G[16] + (P[16] & C[15]);

    // Compute sum (S) signals
    assign S[1] = A[1] ^ B[1] ^ C0;
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign S[4] = A[4] ^ B[4] ^ C[3];
    assign S[5] = A[5] ^ B[5] ^ C[4];
    assign S[6] = A[6] ^ B[6] ^ C[5];
    assign S[7] = A[7] ^ B[7] ^ C[6];
    assign S[8] = A[8] ^ B[8] ^ C[7];
    assign S[9] = A[9] ^ B[9] ^ C[8];
    assign S[10] = A[10] ^ B[10] ^ C[9];
    assign S[11] = A[11] ^ B[11] ^ C[10];
    assign S[12] = A[12] ^ B[12] ^ C[11];
    assign S[13] = A[13] ^ B[13] ^ C[12];
    assign S[14] = A[14] ^ B[14] ^ C[13];
    assign S[15] = A[15] ^ B[15] ^ C[14];
    assign S[16] = A[16] ^ B[16] ^ C[15];

    assign C16 = C[16];

endmodule

// 32-bit carry-lookahead adder module
module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output       C32
);

    wire C16;

    // Instantiate two 16-bit carry-lookahead adder modules
    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C0(1'b0),
        .S(S[16:1]),
        .C16(C16)
    );

    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C0(C16),
        .S(S[32:17]),
        .C16(C32)
    );

endmodule