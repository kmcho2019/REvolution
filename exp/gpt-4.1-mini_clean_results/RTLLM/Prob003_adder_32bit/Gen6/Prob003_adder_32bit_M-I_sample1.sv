module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Gout,  // group generate
    output       Pout,  // group propagate
    output       Cout
);
    wire [4:1] G; // bit generate
    wire [4:1] P; // bit propagate
    wire [4:0] C; // carry signals

    assign G = A & B;
    assign P = A ^ B;

    assign C[0] = Cin;
    // Carry lookahead within 4 bits
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    assign S = P ^ C[3:0];

    // Group propagate and generate for this 4-bit block
    assign Pout = &P; // P1 & P2 & P3 & P4
    assign Gout = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);

    assign Cout = C[4];
endmodule

module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [3:0] Gg; // group generate for each 4-bit block
    wire [3:0] Pg; // group propagate for each 4-bit block
    wire [4:0] Cg; // carries between groups

    wire [4:1] S0, S1, S2, S3;
    wire C0, C1, C2, C3;

    assign Cg[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(Cg[0]),
        .S(S0),
        .Gout(Gg[0]),
        .Pout(Pg[0]),
        .Cout(C0)
    );

    cla_4bit cla1 (
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(Cg[1]),
        .S(S1),
        .Gout(Gg[1]),
        .Pout(Pg[1]),
        .Cout(C1)
    );

    cla_4bit cla2 (
        .A(A[12:9]),
        .B(B[12:9]),
        .Cin(Cg[2]),
        .S(S2),
        .Gout(Gg[2]),
        .Pout(Pg[2]),
        .Cout(C2)
    );

    cla_4bit cla3 (
        .A(A[16:13]),
        .B(B[16:13]),
        .Cin(Cg[3]),
        .S(S3),
        .Gout(Gg[3]),
        .Pout(Pg[3]),
        .Cout(C3)
    );

    // Compute carries between 4-bit groups using group generate and propagate
    // Cg[i+1] = Gg[i] + Pg[i]*Cg[i]
    assign Cg[1] = Gg[0] | (Pg[0] & Cg[0]);
    assign Cg[2] = Gg[1] | (Pg[1] & Cg[1]);
    assign Cg[3] = Gg[2] | (Pg[2] & Cg[2]);
    assign Cg[4] = Gg[3] | (Pg[3] & Cg[3]);

    assign Cout = Cg[4];

    // Concatenate the sums of 4 blocks into the 16-bit output sum
    assign S = {S3, S2, S1, S0};
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(C16),
        .S(S[32:17]),
        .Cout(C32)
    );

endmodule