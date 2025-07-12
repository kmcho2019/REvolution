// 4-bit Carry-Lookahead Adder (CLA) module
module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
);
    wire [3:0] G; // Generate signal
    wire [3:0] P; // Propagate signal
    wire [2:0] C; // Internal carry signals

    // Calculate Generate and Propagate signals
    assign G[0] = A[0] & B[0];
    assign P[0] = A[0] | B[0];
    assign G[1] = A[1] & B[1];
    assign P[1] = A[1] | B[1];
    assign G[2] = A[2] & B[2];
    assign P[2] = A[2] | B[2];
    assign G[3] = A[3] & B[3];
    assign P[3] = A[3] | B[3];

    // Calculate internal carries
    assign C[0] = G[0] | (P[0] & (G[1] | (P[1] & (G[2] | (P[2] & G[3]))));
    assign C[1] = G[1] | (P[1] & (G[2] | (P[2] & G[3])));
    assign C[2] = G[2] | (P[2] & G[3]);

    // Calculate sum and carry-out
    assign S[0] = A[0] ^ B[0];
    assign S[1] = A[1] ^ B[1] ^ C[0];
    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign C_out = G[3] | (P[3] & C[2]);

endmodule

// 16-bit Carry-Lookahead Adder (CLA) module using 4-bit CLA blocks
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    output [15:0] S,
    output C_out
);
    wire C1, C2, C3; // Internal carry signals

    // First 4-bit block
    cla_4bit cla_4bit_1(
        .A(A[3:0]),
        .B(B[3:0]),
        .S(S[3:0]),
        .C_out(C1)
    );

    // Second 4-bit block
    cla_4bit cla_4bit_2(
        .A(A[7:4]),
        .B(B[7:4]),
        .S(S[7:4]),
        .C_out(C2)
    );

    // Third 4-bit block
    cla_4bit cla_4bit_3(
        .A(A[11:8]),
        .B(B[11:8]),
        .S(S[11:8]),
        .C_out(C3)
    );

    // Fourth 4-bit block
    cla_4bit cla_4bit_4(
        .A(A[15:12]),
        .B(B[15:12]),
        .S(S[15:12]),
        .C_out(C_out)
    );

    // Manual carry propagation between blocks (since CLA blocks are designed for 4 bits)
    assign S[3] = S[3] ^ C1;
    assign S[7] = S[7] ^ C2;
    assign S[11] = S[11] ^ C3;
    assign C2 = C1 | (S[3] & C1);
    assign C3 = C2 | (S[7] & C2);
    assign C_out = C3 | (S[11] & C3);

endmodule

// 32-bit Carry-Lookahead Adder (CLA) module using 16-bit CLA blocks
module adder_32bit(
    input [31:1] A,
    input [31:1] B,
    output [31:1] S,
    output C32
);
    wire C16; // Internal carry signal

    // First 16-bit block
    cla_16bit cla_16bit_1(
        .A(A[15:1]),
        .B(B[15:1]),
        .S(S[15:1]),
        .C_out(C16)
    );

    // Second 16-bit block
    cla_16bit cla_16bit_2(
        .A(A[31:16]),
        .B(B[31:16]),
        .S(S[31:16]),
        .C_out(C32)
    );

    // Manual carry propagation between blocks
    assign S[16] = S[16] ^ C16;
    assign C32 = C32 | (S[16] & C16);

endmodule