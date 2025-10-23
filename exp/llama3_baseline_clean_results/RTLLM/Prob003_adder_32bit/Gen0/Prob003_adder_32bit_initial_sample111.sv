// 1-bit full adder
module full_adder(
    input A,
    input B,
    input C_in,
    output S,
    output C_out
);
    assign S = A ^ B ^ C_in;
    assign C_out = (A & B) | (A & C_in) | (B & C_in);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    wire [4:1] G, P;
    wire [3:1] C;

    // calculate G and P
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] | B[4];

    // calculate C
    assign C[1] = G[1] | (P[1] & C_in);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);

    // calculate S and C_out
    full_adder fa1(A[1], B[1], C_in, S[1], );
    full_adder fa2(A[2], B[2], C[1], S[2], );
    full_adder fa3(A[3], B[3], C[2], S[3], );
    full_adder fa4(A[4], B[4], C[3], S[4], C_out);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);
    wire [8:1] G, P;
    wire [15:1] C;
    wire [8:1] C1, C2, C3, C4;

    // calculate G and P
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];
    assign G[4] = A[4] & B[4];
    assign P[4] = A[4] | B[4];
    assign G[5] = A[5] & B[5];
    assign P[5] = A[5] | B[5];
    assign G[6] = A[6] & B[6];
    assign P[6] = A[6] | B[6];
    assign G[7] = A[7] & B[7];
    assign P[7] = A[7] | B[7];
    assign G[8] = A[8] & B[8];
    assign P[8] = A[8] | B[8];
    assign G[9] = A[9] & B[9];
    assign P[9] = A[9] | B[9];
    assign G[10] = A[10] & B[10];
    assign P[10] = A[10] | B[10];
    assign G[11] = A[11] & B[11];
    assign P[11] = A[11] | B[11];
    assign G[12] = A[12] & B[12];
    assign P[12] = A[12] | B[12];
    assign G[13] = A[13] & B[13];
    assign P[13] = A[13] | B[13];
    assign G[14] = A[14] & B[14];
    assign P[14] = A[14] | B[14];
    assign G[15] = A[15] & B[15];
    assign P[15] = A[15] | B[15];
    assign G[16] = A[16] & B[16];
    assign P[16] = A[16] | B[16];

    // calculate C
    assign C1[1] = G[1] | (P[1] & C_in);
    assign C1[2] = G[2] | (P[2] & C1[1]);
    assign C1[3] = G[3] | (P[3] & C1[2]);
    assign C1[4] = G[4] | (P[4] & C1[3]);

    assign C2[1] = G[5] | (P[5] & C1[4]);
    assign C2[2] = G[6] | (P[6] & C2[1]);
    assign C2[3] = G[7] | (P[7] & C2[2]);
    assign C2[4] = G[8] | (P[8] & C2[3]);

    assign C3[1] = G[9] | (P[9] & C2[4]);
    assign C3[2] = G[10] | (P[10] & C3[1]);
    assign C3[3] = G[11] | (P[11] & C3[2]);
    assign C3[4] = G[12] | (P[12] & C3[3]);

    assign C4[1] = G[13] | (P[13] & C3[4]);
    assign C4[2] = G[14] | (P[14] & C4[1]);
    assign C4[3] = G[15] | (P[15] & C4[2]);
    assign C4[4] = G[16] | (P[16] & C4[3]);

    // calculate S and C_out
    full_adder fa1(A[1], B[1], C_in, S[1], );
    full_adder fa2(A[2], B[2], C1[1], S[2], );
    full_adder fa3(A[3], B[3], C1[2], S[3], );
    full_adder fa4(A[4], B[4], C1[3], S[4], );
    full_adder fa5(A[5], B[5], C1[4], S[5], );
    full_adder fa6(A[6], B[6], C2[1], S[6], );
    full_adder fa7(A[7], B[7], C2[2], S[7], );
    full_adder fa8(A[8], B[8], C2[3], S[8], );
    full_adder fa9(A[9], B[9], C2[4], S[9], );
    full_adder fa10(A[10], B[10], C3[1], S[10], );
    full_adder fa11(A[11], B[11], C3[2], S[11], );
    full_adder fa12(A[12], B[12], C3[3], S[12], );
    full_adder fa13(A[13], B[13], C3[4], S[13], );
    full_adder fa14(A[14], B[14], C4[1], S[14], );
    full_adder fa15(A[15], B[15], C4[2], S[15], );
    full_adder fa16(A[16], B[16], C4[3], S[16], C_out);
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    cla_16bit cla1(A[16:1], B[16:1], 1'b0, S[16:1], C16);
    cla_16bit cla2(A[32:17], B[32:17], C16, S[32:17], C32);
endmodule