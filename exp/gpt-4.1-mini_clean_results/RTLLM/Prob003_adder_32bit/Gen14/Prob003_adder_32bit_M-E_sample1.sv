module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       Cout,
    output       Pout, // Group propagate
    output       Gout  // Group generate
);
    wire [4:1] P; // Propagate
    wire [4:1] G; // Generate
    wire [4:0] C; // Carry signals

    assign P = A ^ B;
    assign G = A & B;

    assign C[0] = Cin;
    // Carry lookahead equations for 4 bits
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & C[0]);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & C[0]);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) |
                  (P[4] & P[3] & P[2] & P[1] & C[0]);

    assign S = P ^ C[3:0];

    // Group propagate and generate
    assign Pout = &P; // All propagate signals ANDed
    assign Gout = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);

    assign Cout = C[4];
endmodule

module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [3:0] P_group, G_group; // Group propagate and generate for 4-bit blocks
    wire [4:0] C; // Carry signals for groups

    assign C[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (
        .A   (A[4:1]),
        .B   (B[4:1]),
        .Cin (C[0]),
        .S   (S[4:1]),
        .Cout(),
        .Pout(P_group[0]),
        .Gout(G_group[0])
    );

    cla_4bit cla1 (
        .A   (A[8:5]),
        .B   (B[8:5]),
        .Cin (C[1]),
        .S   (S[8:5]),
        .Cout(),
        .Pout(P_group[1]),
        .Gout(G_group[1])
    );

    cla_4bit cla2 (
        .A   (A[12:9]),
        .B   (B[12:9]),
        .Cin (C[2]),
        .S   (S[12:9]),
        .Cout(),
        .Pout(P_group[2]),
        .Gout(G_group[2])
    );

    cla_4bit cla3 (
        .A   (A[16:13]),
        .B   (B[16:13]),
        .Cin (C[3]),
        .S   (S[16:13]),
        .Cout(),
        .Pout(P_group[3]),
        .Gout(G_group[3])
    );

    // Compute carries for groups using 4-bit CLA style equations
    // Carry lookahead for 4 groups
    assign C[1] = G_group[0] | (P_group[0] & C[0]);
    assign C[2] = G_group[1] | (P_group[1] & G_group[0]) | (P_group[1] & P_group[0] & C[0]);
    assign C[3] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & G_group[0]) | (P_group[2] & P_group[1] & P_group[0] & C[0]);
    assign C[4] = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & G_group[0]) |
                  (P_group[3] & P_group[2] & P_group[1] & P_group[0] & C[0]);

    assign Cout = C[4];
endmodule

module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit lower16 (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit upper16 (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule