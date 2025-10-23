// 16-bit Carry-Lookahead Adder with optimized carry generation
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [16:1] g, p; // Generate and propagate signals
    assign g[1] = A[1] & B[1];
    assign p[1] = A[1] ^ B[1];
    assign S[1] = p[1] ^ Cin;
    assign g[2] = A[2] & B[2];
    assign p[2] = A[2] ^ B[2];
    assign S[2] = p[2] ^ (g[1] | (p[1] & Cin));
    assign g[3] = A[3] & B[3];
    assign p[3] = A[3] ^ B[3];
    assign S[3] = p[3] ^ (g[2] | (p[2] & (g[1] | (p[1] & Cin))));
    //... (apply the same pattern for the remaining bits)
    assign g[16] = A[16] & B[16];
    assign p[16] = A[16] ^ B[16];
    assign S[16] = p[16] ^ (g[15] | (p[15] & (g[14] | (p[14] & (g[13] | (p[13] & (g[12] | (p[12] & (g[11] | (p[11] & (g[10] | (p[10] & (g[9] | (p[9] & (g[8] | (p[8] & (g[7] | (p[7] & (g[6] | (p[6] & (g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & Cin))))))))))))))))))))))));
    assign Cout = g[16] | (p[16] & (g[15] | (p[15] & (g[14] | (p[14] & (g[13] | (p[13] & (g[12] | (p[12] & (g[11] | (p[11] & (g[10] | (p[10] & (g[9] | (p[9] & (g[8] | (p[8] & (g[7] | (p[7] & (g[6] | (p[6] & (g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & Cin))))))))))))))))))))))));
endmodule

// 32-bit Carry-Lookahead Adder using optimized 16-bit CLA blocks
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