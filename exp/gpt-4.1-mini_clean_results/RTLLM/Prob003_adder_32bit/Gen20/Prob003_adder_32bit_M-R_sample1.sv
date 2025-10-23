module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] P, G;
    wire [16:0] C;

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Level 1: Individual bit carries
    wire [15:1] C1;
    assign C1[1] = G[1] | (P[1] & C[0]);
    assign C1[2] = G[2] | (P[2] & C1[1]);
    assign C1[3] = G[3] | (P[3] & C1[2]);
    assign C1[4] = G[4] | (P[4] & C1[3]);
    assign C1[5] = G[5] | (P[5] & C1[4]);
    assign C1[6] = G[6] | (P[6] & C1[5]);
    assign C1[7] = G[7] | (P[7] & C1[6]);
    assign C1[8] = G[8] | (P[8] & C1[7]);
    assign C1[9] = G[9] | (P[9] & C1[8]);
    assign C1[10]= G[10]| (P[10]& C1[9]);
    assign C1[11]= G[11]| (P[11]& C1[10]);
    assign C1[12]= G[12]| (P[12]& C1[11]);
    assign C1[13]= G[13]| (P[13]& C1[12]);
    assign C1[14]= G[14]| (P[14]& C1[13]);
    assign C1[15]= G[15]| (P[15]& C1[14]);
    assign C1[16]= G[16]| (P[16]& C1[15]);

    assign C[16:1] = C1[16:1];

    assign S = P ^ C[15:0];
    assign Cout = C[16];
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit lower (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit upper (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule