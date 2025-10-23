// 4-bit Carry-Lookahead Adder using Ladner-Fischer architecture
module cla_4bit_ladner(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    wire [3:1] C;

    // Compute carry bits using Ladner-Fischer architecture
    assign C[1] = A[1] & B[1] | (A[1] ^ B[1]) & C_in;
    assign C[2] = A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & C_in);
    assign C[3] = A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & C_in));

    // Compute sum bits
    assign S[1] = A[1] ^ B[1] ^ C_in;
    assign S[2] = A[2] ^ B[2] ^ (A[1] & B[1] | (A[1] ^ B[1]) & C_in);
    assign S[3] = A[3] ^ B[3] ^ (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & C_in));
    assign S[4] = A[4] ^ B[4] ^ (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & C_in)));

    // Compute carry-out
    assign C_out = A[4] & B[4] | (A[4] ^ B[4]) & (A[3] & B[3] | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & C_in)));

endmodule

// 16-bit Carry-Lookahead Adder using Ladner-Fischer architecture
module cla_16bit_ladner(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);
    wire C4, C8, C12;

    cla_4bit_ladner u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S[4:1]),
        .C_out(C4)
    );

    cla_4bit_ladner u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C4),
        .S(S[8:5]),
        .C_out(C8)
    );

    cla_4bit_ladner u3(
        .A(A[12:9]),
        .B(B[12:9]),
        .C_in(C8),
        .S(S[12:9]),
        .C_out(C12)
    );

    cla_4bit_ladner u4(
        .A(A[16:13]),
        .B(B[16:13]),
        .C_in(C12),
        .S(S[16:13]),
        .C_out(C_out)
    );

endmodule

// 32-bit Carry-Lookahead Adder using Ladner-Fischer architecture
module adder_32bit_ladner(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;

    cla_16bit_ladner u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla_16bit_ladner u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );

endmodule