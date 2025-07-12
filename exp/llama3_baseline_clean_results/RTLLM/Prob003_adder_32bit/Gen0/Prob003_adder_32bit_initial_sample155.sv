// 4-bit carry-lookahead adder block
module cla_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire G0, G1, G2, G3;
    wire P0, P1, P2, P3;
    wire C1, C2, C3;

    // Calculate generate and propagate signals
    assign G0 = A[0] & B[0];
    assign G1 = A[1] & B[1];
    assign G2 = A[2] & B[2];
    assign G3 = A[3] & B[3];

    assign P0 = A[0] | B[0];
    assign P1 = A[1] | B[1];
    assign P2 = A[2] | B[2];
    assign P3 = A[3] | B[3];

    // Calculate carry signals
    assign C1 = G0 | (P0 & Cin);
    assign C2 = G1 | (P1 & C1);
    assign C3 = G2 | (P2 & C2);

    // Calculate sum signals
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign S[1] = A[1] ^ B[1] ^ C1;
    assign S[2] = A[2] ^ B[2] ^ C2;
    assign S[3] = A[3] ^ B[3] ^ C3;

    // Calculate carry-out
    assign Cout = G3 | (P3 & C3);
endmodule

// 16-bit carry-lookahead adder block
module cla_16bit(
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;

    cla_4bit cla_0(
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(C[0])
    );

    cla_4bit cla_1(
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C[0]),
        .S(S[7:4]),
        .Cout(C[1])
    );

    cla_4bit cla_2(
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C[1]),
        .S(S[11:8]),
        .Cout(C[2])
    );

    cla_4bit cla_3(
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C[2]),
        .S(S[15:12]),
        .Cout(Cout)
    );
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [31:1] A,
    input [31:1] B,
    output [31:1] S,
    output C32
);
    wire Cout_16;

    cla_16bit cla_0(
        .A(A[15:1]),
        .B(B[15:1]),
        .Cin(1'b0),
        .S(S[15:1]),
        .Cout(Cout_16)
    );

    cla_16bit cla_1(
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(Cout_16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule