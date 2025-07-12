module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       P_group,
    output       G_group
);
    wire [4:1] P, G;
    wire [4:0] C;

    assign P = A ^ B;
    assign G = A & B;
    assign C[0] = Cin;

    // Carry lookahead logic within 4 bits
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    assign C[4] = G[4] | (P[4] & C[3]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group propagate and generate signals for 4-bit block
    assign P_group = &P; // AND of all propagate bits
    assign G_group = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);
endmodule

module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [4:1] P_group, G_group; // 4 groups of 4 bits
    wire [5:0] C; // carry signals for groups

    assign C[0] = Cin;

    // Instantiate 4 x 4-bit CLAs
    cla_4bit cla0 (
        .A       (A[4:1]),
        .B       (B[4:1]),
        .Cin     (C[0]),
        .S       (S[4:1]),
        .Cout    (),
        .P_group (P_group[1]),
        .G_group (G_group[1])
    );

    cla_4bit cla1 (
        .A       (A[8:5]),
        .B       (B[8:5]),
        .Cin     (C[1]),
        .S       (S[8:5]),
        .Cout    (),
        .P_group (P_group[2]),
        .G_group (G_group[2])
    );

    cla_4bit cla2 (
        .A       (A[12:9]),
        .B       (B[12:9]),
        .Cin     (C[2]),
        .S       (S[12:9]),
        .Cout    (),
        .P_group (P_group[3]),
        .G_group (G_group[3])
    );

    cla_4bit cla3 (
        .A       (A[16:13]),
        .B       (B[16:13]),
        .Cin     (C[3]),
        .S       (S[16:13]),
        .Cout    (),
        .P_group (P_group[4]),
        .G_group (G_group[4])
    );

    // Carry lookahead logic between 4-bit groups
    assign C[1] = G_group[1] | (P_group[1] & C[0]);
    assign C[2] = G_group[2] | (P_group[2] & C[1]);
    assign C[3] = G_group[3] | (P_group[3] & C[2]);
    assign C[4] = G_group[4] | (P_group[4] & C[3]);
    assign Cout = C[4];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit lower_half (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit upper_half (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule