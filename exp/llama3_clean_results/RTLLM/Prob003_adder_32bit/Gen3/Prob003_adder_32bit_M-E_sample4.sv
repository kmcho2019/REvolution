// 8-bit Ripple-Carry Adder
module rca_8bit(
    input [8:1] A,
    input [8:1] B,
    output [8:1] S,
    output C_out,
    input C_in
);

    wire [7:1] C;  // Carry

    // Calculate Sum and Carry signals
    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign C[1] = (A[1] & B[1]) | (A[1] & C_in) | (B[1] & C_in);

    assign S[2] = A[2] ^ B[2] ^ C[1];
    assign C[2] = (A[2] & B[2]) | (A[2] & C[1]) | (B[2] & C[1]);

    assign S[3] = A[3] ^ B[3] ^ C[2];
    assign C[3] = (A[3] & B[3]) | (A[3] & C[2]) | (B[3] & C[2]);

    assign S[4] = A[4] ^ B[4] ^ C[3];
    assign C[4] = (A[4] & B[4]) | (A[4] & C[3]) | (B[4] & C[3]);

    assign S[5] = A[5] ^ B[5] ^ C[4];
    assign C[5] = (A[5] & B[5]) | (A[5] & C[4]) | (B[5] & C[4]);

    assign S[6] = A[6] ^ B[6] ^ C[5];
    assign C[6] = (A[6] & B[6]) | (A[6] & C[5]) | (B[6] & C[5]);

    assign S[7] = A[7] ^ B[7] ^ C[6];
    assign C[7] = (A[7] & B[7]) | (A[7] & C[6]) | (B[7] & C[6]);

    assign S[8] = A[8] ^ B[8] ^ C[7];
    assign C_out = (A[8] & B[8]) | (A[8] & C[7]) | (B[8] & C[7]);

endmodule

// Pipelined Carry-Lookahead Adder (PCLA)
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

    wire C8, C16, C24;  // Carry signals

    rca_8bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .S(S[8:1]),
        .C_out(C8),
        .C_in(1'b0)
    );

    rca_8bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .S(S[16:9]),
        .C_out(C16),
        .C_in(C8)
    );

    rca_8bit u3(
        .A(A[24:17]),
        .B(B[24:17]),
        .S(S[24:17]),
        .C_out(C24),
        .C_in(C16)
    );

    rca_8bit u4(
        .A(A[32:25]),
        .B(B[32:25]),
        .S(S[32:25]),
        .C_out(C32),
        .C_in(C24)
    );

endmodule