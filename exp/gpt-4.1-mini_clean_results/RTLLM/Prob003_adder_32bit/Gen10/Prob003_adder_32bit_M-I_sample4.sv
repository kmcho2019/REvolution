module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout,
    output       Pg,   // Group propagate
    output       Gg    // Group generate
);
    wire [3:0] P = A ^ B; // Propagate signals
    wire [3:0] G = A & B; // Generate signals

    wire c1, c2, c3;

    // Carry signals
    assign c1 = G[0] | (P[0] & Cin);
    assign c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);

    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ c1;
    assign S[2] = P[2] ^ c2;
    assign S[3] = P[3] ^ c3;

    // Group propagate and generate
    assign Pg = &P; // AND of all propagates
    assign Gg = Cout;
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0] Pg, Gg;         // Group propagate and generate for 4-bit blocks
    wire [4:0] C;              // Carry signals between blocks

    assign C[0] = Cin;

    wire [3:0] S0, S1, S2, S3;

    // Four 4-bit CLA blocks
    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(C[0]),
        .S(S0),
        .Cout(),
        .Pg(Pg[0]),
        .Gg(Gg[0])
    );

    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(C[1]),
        .S(S1),
        .Cout(),
        .Pg(Pg[1]),
        .Gg(Gg[1])
    );

    cla_4bit cla2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(C[2]),
        .S(S2),
        .Cout(),
        .Pg(Pg[2]),
        .Gg(Gg[2])
    );

    cla_4bit cla3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(C[3]),
        .S(S3),
        .Cout(),
        .Pg(Pg[3]),
        .Gg(Gg[3])
    );

    // Carry lookahead logic for 4-bit groups
    assign C[1] = Gg[0] | (Pg[0] & C[0]);
    assign C[2] = Gg[1] | (Pg[1] & Gg[0]) | (Pg[1] & Pg[0] & C[0]);
    assign C[3] = Gg[2] | (Pg[2] & Gg[1]) | (Pg[2] & Pg[1] & Gg[0]) | (Pg[2] & Pg[1] & Pg[0] & C[0]);
    assign C[4] = Gg[3] | (Pg[3] & Gg[2]) | (Pg[3] & Pg[2] & Gg[1]) | (Pg[3] & Pg[2] & Pg[1] & Gg[0]) | (Pg[3] & Pg[2] & Pg[1] & Pg[0] & C[0]);

    // Combine sums
    assign S = {S3, S2, S1, S0};
    assign Cout = C[4];
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    // Internally zero-based slicing
    wire [15:0] A_low  = A[16:1];
    wire [15:0] B_low  = B[16:1];
    wire [15:0] A_high = A[32:17];
    wire [15:0] B_high = B[32:17];

    wire [15:0] S_low, S_high;

    cla_16bit cla_lower (
        .A(A_low),
        .B(B_low),
        .Cin(1'b0),
        .S(S_low),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A_high),
        .B(B_high),
        .Cin(C16),
        .S(S_high),
        .Cout(C32)
    );

    assign S[16:1]  = S_low;
    assign S[32:17] = S_high;
endmodule