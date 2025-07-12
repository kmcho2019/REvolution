// 1-bit full adder
module full_adder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);
    assign S = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule

// 4-bit carry-lookahead adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout
);
    wire [3:1] C;

    full_adder u1(
        .A(A[1]),
        .B(B[1]),
        .Cin(Cin),
        .S(S[1]),
        .Cout(C[1])
    );

    full_adder u2(
        .A(A[2]),
        .B(B[2]),
        .Cin(C[1]),
        .S(S[2]),
        .Cout(C[2])
    );

    full_adder u3(
        .A(A[3]),
        .B(B[3]),
        .Cin(C[2]),
        .S(S[3]),
        .Cout(C[3])
    );

    full_adder u4(
        .A(A[4]),
        .B(B[4]),
        .Cin(C[3]),
        .S(S[4]),
        .Cout(Cout)
    );
endmodule

// 8-bit carry-lookahead adder
module cla_8bit(
    input [8:1] A,
    input [8:1] B,
    input Cin,
    output [8:1] S,
    output Cout
);
    wire C4;

    cla_4bit u1(
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(Cin),
        .S(S[4:1]),
        .Cout(C4)
    );

    cla_4bit u2(
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(C4),
        .S(S[8:5]),
        .Cout(Cout)
    );
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire C8;

    cla_8bit u1(
        .A(A[8:1]),
        .B(B[8:1]),
        .Cin(Cin),
        .S(S[8:1]),
        .Cout(C8)
    );

    cla_8bit u2(
        .A(A[16:9]),
        .B(B[16:9]),
        .Cin(C8),
        .S(S[16:9]),
        .Cout(Cout)
    );
endmodule

// 32-bit carry-lookahead adder
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
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit u2(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule