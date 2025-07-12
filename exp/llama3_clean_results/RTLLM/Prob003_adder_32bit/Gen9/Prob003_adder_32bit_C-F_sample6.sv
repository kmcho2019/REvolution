// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    input C_in,
    output [3:0] S,
    output C_out
);

    assign S[0] = A[0] ^ B[0] ^ C_in;
    assign S[1] = A[1] ^ B[1] ^ (A[0] & B[0] | (A[0] ^ B[0]) & C_in);
    assign S[2] = A[2] ^ B[2] ^ (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in));
    assign S[3] = A[3] ^ B[3] ^ (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in)));
    assign C_out = (A[3] & B[3]) | (A[3] ^ B[3]) & (A[2] & B[2] | (A[2] ^ B[2]) & (A[1] & B[1] | (A[1] ^ B[1]) & (A[0] & B[0] | (A[0] ^ B[0]) & C_in)));

endmodule

// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [7:0] A,
    input [7:0] B,
    input C_in,
    output [7:0] S,
    output C_out
);

    wire C4;

    cla_4bit u1(
        .A(A[3:0]),
        .B(B[3:0]),
        .C_in(C_in),
        .S(S[3:0]),
        .C_out(C4)
    );

    cla_4bit u2(
        .A(A[7:4]),
        .B(B[7:4]),
        .C_in(C4),
        .S(S[7:4]),
        .C_out(C_out)
    );

endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] S,
    output C32
);

    wire C8, C16, C24;

    cla_8bit u1(
        .A(A[7:0]),
        .B(B[7:0]),
        .C_in(1'b0),
        .S(S[7:0]),
        .C_out(C8)
    );

    cla_8bit u2(
        .A(A[15:8]),
        .B(B[15:8]),
        .C_in(C8),
        .S(S[15:8]),
        .C_out(C16)
    );

    cla_8bit u3(
        .A(A[23:16]),
        .B(B[23:16]),
        .C_in(C16),
        .S(S[23:16]),
        .C_out(C24)
    );

    cla_8bit u4(
        .A(A[31:24]),
        .B(B[31:24]),
        .C_in(C24),
        .S(S[31:24]),
        .C_out(C32)
    );

endmodule