// 4-bit CLA submodule
module cla_4bit (
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       P,    // block propagate
    output       G,    // block generate
    output       Cout
);
    wire [4:1] P_bit;   // propagate signals per bit
    wire [4:1] G_bit;   // generate signals per bit
    wire [4:0] C;       // carry signals

    assign P_bit = A ^ B;
    assign G_bit = A & B;

    assign C[0] = Cin;
    // Carry lookahead equations inside 4-bit block
    assign C[1] = G_bit[1] | (P_bit[1] & C[0]);
    assign C[2] = G_bit[2] | (P_bit[2] & G_bit[1]) | (P_bit[2] & P_bit[1] & C[0]);
    assign C[3] = G_bit[3] | (P_bit[3] & G_bit[2]) | (P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[3] & P_bit[2] & P_bit[1] & C[0]);
    assign C[4] = G_bit[4] | (P_bit[4] & G_bit[3]) | (P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]) | (P_bit[4] & P_bit[3] & P_bit[2] & P_bit[1] & C[0]);

    assign S = P_bit ^ C[3:0];
    assign Cout = C[4];

    // Block propagate: all bits propagate
    assign P = &P_bit;
    // Block generate: generate or propagate & previous generate in block
    assign G = G_bit[4] | (P_bit[4] & G_bit[3]) | (P_bit[4] & P_bit[3] & G_bit[2]) | (P_bit[4] & P_bit[3] & P_bit[2] & G_bit[1]);
endmodule

// 16-bit CLA with hierarchical 4-bit blocks
module cla_16bit (
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [3:0] P_group; // propagate for each 4-bit block
    wire [3:0] G_group; // generate for each 4-bit block
    wire [4:0] C_group; // carry signals for groups

    assign C_group[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (
        .A   (A[4:1]),
        .B   (B[4:1]),
        .Cin (C_group[0]),
        .S   (S[4:1]),
        .P   (P_group[0]),
        .G   (G_group[0]),
        .Cout()
    );

    cla_4bit cla1 (
        .A   (A[8:5]),
        .B   (B[8:5]),
        .Cin (C_group[1]),
        .S   (S[8:5]),
        .P   (P_group[1]),
        .G   (G_group[1]),
        .Cout()
    );

    cla_4bit cla2 (
        .A   (A[12:9]),
        .B   (B[12:9]),
        .Cin (C_group[2]),
        .S   (S[12:9]),
        .P   (P_group[2]),
        .G   (G_group[2]),
        .Cout()
    );

    cla_4bit cla3 (
        .A   (A[16:13]),
        .B   (B[16:13]),
        .Cin (C_group[3]),
        .S   (S[16:13]),
        .P   (P_group[3]),
        .G   (G_group[3]),
        .Cout()
    );

    // Carry lookahead logic for groups (4 groups of 4 bits)
    assign C_group[1] = G_group[0] | (P_group[0] & C_group[0]);
    assign C_group[2] = G_group[1] | (P_group[1] & G_group[0]) | (P_group[1] & P_group[0] & C_group[0]);
    assign C_group[3] = G_group[2] | (P_group[2] & G_group[1]) | (P_group[2] & P_group[1] & G_group[0]) | (P_group[2] & P_group[1] & P_group[0] & C_group[0]);
    assign C_group[4] = G_group[3] | (P_group[3] & G_group[2]) | (P_group[3] & P_group[2] & G_group[1]) | (P_group[3] & P_group[2] & P_group[1] & G_group[0]) | (P_group[3] & P_group[2] & P_group[1] & P_group[0] & C_group[0]);

    assign Cout = C_group[4];
endmodule

// Top-level 32-bit adder with two 16-bit CLA blocks
module adder_32bit (
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire C16;

    cla_16bit cla_low (
        .A   (A[16:1]),
        .B   (B[16:1]),
        .Cin (1'b0),
        .S   (S[16:1]),
        .Cout(C16)
    );

    cla_16bit cla_high (
        .A   (A[32:17]),
        .B   (B[32:17]),
        .Cin (C16),
        .S   (S[32:17]),
        .Cout(C32)
    );
endmodule