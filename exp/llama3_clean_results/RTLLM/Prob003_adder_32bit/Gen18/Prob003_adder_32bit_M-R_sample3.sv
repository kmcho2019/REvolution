// 1-bit Full Adder
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

// 4-bit Carry-Lookahead Adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input C_in,
    output [4:1] S,
    output C_out
);
    wire C1, C2, C3;

    full_adder u1(
        .A(A[1]),
        .B(B[1]),
        .C_in(C_in),
        .S(S[1]),
        .C_out(C1)
    );

    full_adder u2(
        .A(A[2]),
        .B(B[2]),
        .C_in(C1),
        .S(S[2]),
        .C_out(C2)
    );

    full_adder u3(
        .A(A[3]),
        .B(B[3]),
        .C_in(C2),
        .S(S[3]),
        .C_out(C3)
    );

    full_adder u4(
        .A(A[4]),
        .B(B[4]),
        .C_in(C3),
        .S(S[4]),
        .C_out(C_out)
    );
endmodule

// 8-bit Carry-Lookahead Adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input C_in,
    output [8:1] S,
    output C_out
);
    wire C4;

    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .C_in(C_in),
        .S(S[4:1]),
        .C_out(C4)
    );

    cla_4bit u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .C_in(C4),
        .S(S[8:5]),
        .C_out(C_out)
    );
endmodule

// 16-bit Carry-Lookahead Adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C_in,
    output [16:1] S,
    output C_out
);
    wire C8;

    cla_8bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .C_in(C_in),
        .S(S[8:1]),
        .C_out(C8)
    );

    cla_8bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .C_in(C8),
        .S(S[16:9]),
        .C_out(C_out)
    );
endmodule

// 32-bit Carry-Lookahead Adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;

    cla_16bit u1(
        .A(A[16:1]),
        .B(B[16:1]),
        .C_in(1'b0),
        .S(S[16:1]),
        .C_out(C16)
    );

    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .C_in(C16),
        .S(S[32:17]),
        .C_out(C32)
    );
endmodule