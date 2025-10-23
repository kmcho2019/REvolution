module cla_8bit (
    input  [8:1] A,
    input  [8:1] B,
    input        Cin,
    output [8:1] S,
    output       Cout
);
    wire [8:1] P;    // Propagate signals
    wire [8:1] G;    // Generate signals
    wire [8:0] C;    // Carry signals

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;

    // Carry lookahead logic:
    // C[i] = G[i] + P[i]*C[i-1]
    // Use expanded logic for parallel carry computation
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[5] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) | (P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[6] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[7] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);
    assign C[8] = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]) | (P[8] & P[7] & P[6] & P[5] & G[4]) | (P[8] & P[7] & P[6] & P[5] & P[4] & G[3]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[8] & P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & C[0]);

    // Sum bits: S[i] = P[i] xor C[i-1]
    assign S = P ^ C[7:0];

    assign Cout = C[8];
endmodule


module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C8, C16, C24;

    // Instantiate four 8-bit CLA blocks connected by carry-out to next carry-in
    cla_8bit cla0 (
        .A   (A[8:1]),
        .B   (B[8:1]),
        .Cin (1'b0),
        .S   (S[8:1]),
        .Cout(C8)
    );

    cla_8bit cla1 (
        .A   (A[16:9]),
        .B   (B[16:9]),
        .Cin (C8),
        .S   (S[16:9]),
        .Cout(C16)
    );

    cla_8bit cla2 (
        .A   (A[24:17]),
        .B   (B[24:17]),
        .Cin (C16),
        .S   (S[24:17]),
        .Cout(C24)
    );

    cla_8bit cla3 (
        .A   (A[32:25]),
        .B   (B[32:25]),
        .Cin (C24),
        .S   (S[32:25]),
        .Cout(C32)
    );

endmodule