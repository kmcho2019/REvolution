// 4-bit carry-lookahead adder
module cla_4bit(
    input [4:1] A,
    input [4:1] B,
    input Cin,
    output [4:1] S,
    output Cout
);
    wire [3:0] G; // generate signal
    wire [3:0] P; // propagate signal
    wire [2:0] C; // internal carry signals

    // calculate generate and propagate signals
    assign G[0] = A[1] & B[1];
    assign P[0] = A[1] ^ B[1];
    assign G[1] = A[2] & B[2];
    assign P[1] = A[2] ^ B[2];
    assign G[2] = A[3] & B[3];
    assign P[2] = A[3] ^ B[3];
    assign G[3] = A[4] & B[4];
    assign P[3] = A[4] ^ B[4];

    // calculate internal carry signals
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[2] = G[2] | (P[2] & C[2]);

    // calculate sum
    assign S[1] = P[0] ^ C[0];
    assign S[2] = P[1] ^ C[1];
    assign S[3] = P[2] ^ C[2];
    assign S[4] = P[3] ^ (G[3] | (P[3] & C[2]));

    // calculate carry-out
    assign Cout = G[3] | (P[3] & C[2]);
endmodule

// 16-bit carry-lookahead adder
module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input Cin,
    output [16:1] S,
    output Cout
);
    wire [8:0] G; // generate signal
    wire [8:0] P; // propagate signal
    wire [7:0] C; // internal carry signals
    wire [8:1] sum; // internal sum

    // divide 16-bit into four 4-bit blocks
    cla_4bit cla_4bit_1(
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(Cin),
        .S(sum[4:1]),
        .Cout(C[0])
    );

    cla_4bit cla_4bit_2(
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(C[0]),
        .S(sum[8:5]),
        .Cout(C[1])
    );

    cla_4bit cla_4bit_3(
        .A(A[12:9]),
        .B(B[12:9]),
        .Cin(C[1]),
        .S(sum[12:9]),
        .Cout(C[2])
    );

    cla_4bit cla_4bit_4(
        .A(A[16:13]),
        .B(B[16:13]),
        .Cin(C[2]),
        .S(sum[16:13]),
        .Cout(Cout)
    );

    // assign sum output
    assign S = sum;
endmodule

// 32-bit carry-lookahead adder
module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output Cout
);
    wire [16:1] sum_16; // internal sum
    wire Cout_16; // internal carry-out

    // divide 32-bit into two 16-bit blocks
    cla_16bit cla_16bit_1(
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(sum_16),
        .Cout(Cout_16)
    );

    cla_16bit cla_16bit_2(
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(Cout_16),
        .S(S[32:17]),
        .Cout(Cout)
    );

    // assign sum output
    assign S[16:1] = sum_16;
endmodule