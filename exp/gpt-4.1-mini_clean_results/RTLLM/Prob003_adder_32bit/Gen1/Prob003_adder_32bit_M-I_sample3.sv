module cla_4bit(
    input  [4:1] A,
    input  [4:1] B,
    input        Cin,
    output [4:1] S,
    output       P_group,
    output       G_group,
    output       Cout
);
    wire [4:1] G; // generate for each bit
    wire [4:1] P; // propagate for each bit
    wire [5:0] C; // carry signals (C[1] to C[5])

    assign G = A & B;
    assign P = A ^ B;
    assign C[1] = Cin;

    // Carry computation using CLA logic for 4 bits:
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);

    assign S = P ^ C[4:1];
    assign Cout = C[5];

    // Group Propagate and Generate signals for the 4-bit block:
    assign P_group = &P; // AND of all P bits
    assign G_group = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);

endmodule

module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    // Divide 16 bits into four 4-bit CLA blocks
    wire [3:0] P_group; // propagate of each 4-bit group
    wire [3:0] G_group; // generate of each 4-bit group
    wire [4:0] C;       // carries between groups, C[0]=Cin

    wire [4:1] Cout_4bit; // carry out of each 4-bit block (internal)

    assign C[0] = Cin;

    // Instantiate 4 blocks of 4-bit CLA
    cla_4bit cla_blk0 (
        .A(A[4:1]),
        .B(B[4:1]),
        .Cin(C[0]),
        .S(S[4:1]),
        .P_group(P_group[0]),
        .G_group(G_group[0]),
        .Cout(Cout_4bit[1])
    );

    cla_4bit cla_blk1 (
        .A(A[8:5]),
        .B(B[8:5]),
        .Cin(1'b0), // temp, real carry will be assigned after carry computation
        .S(S[8:5]),
        .P_group(P_group[1]),
        .G_group(G_group[1]),
        .Cout(Cout_4bit[2])
    );

    cla_4bit cla_blk2 (
        .A(A[12:9]),
        .B(B[12:9]),
        .Cin(1'b0),
        .S(S[12:9]),
        .P_group(P_group[2]),
        .G_group(G_group[2]),
        .Cout(Cout_4bit[3])
    );

    cla_4bit cla_blk3 (
        .A(A[16:13]),
        .B(B[16:13]),
        .Cin(1'b0),
        .S(S[16:13]),
        .P_group(P_group[3]),
        .G_group(G_group[3]),
        .Cout(Cout_4bit[4])
    );

    // Compute carries into each group with group P and G signals:
    // Using the CLA carry-lookahead equations:
    assign C[1] = G_group[0] | (P_group[0] & C[0]);
    assign C[2] = G_group[1] | (P_group[1] & C[1]);
    assign C[3] = G_group[2] | (P_group[2] & C[2]);
    assign C[4] = G_group[3] | (P_group[3] & C[3]);
    assign Cout = C[4];

    // After computing carries into groups C[1..4], we must feed carry-in signals to each 4-bit block:
    // Because each 4-bit block instance has Cin input, we need to re-instantiate each block with correct Cin.
    // Since Verilog module instantiations are static, we do the sum recomputation manually here.

    // To avoid double instantiation, recode 4-bit blocks summation internally using known carry ins:

    // We can rewrite the above blocks as generate blocks internally.

    // Let's implement the 4-bit sum recomputation inline, as the first instantiation of 4-bit blocks had dummy Cin=0.

    // Internal wires for per-bit generate and propagate signals:
    wire [16:1] G;
    wire [16:1] P;
    wire [17:0] carry_internal; // carry_internal[1] = Cin

    assign G = A & B;
    assign P = A ^ B;
    assign carry_internal[1] = Cin;

    // Carry into each bit using hierarchical group carries:
    // carry_internal at bit boundaries:
    assign carry_internal[5]  = C[1]; // carry into bit 5 (i.e., bit 4 + 1)
    assign carry_internal[9]  = C[2];
    assign carry_internal[13] = C[3];
    assign carry_internal[17] = C[4];

    // Now compute carries within each 4-bit block by ripple with these group carry-ins:
    // For bits 1-4
    assign carry_internal[2] = G[1] | (P[1] & carry_internal[1]);
    assign carry_internal[3] = G[2] | (P[2] & carry_internal[2]);
    assign carry_internal[4] = G[3] | (P[3] & carry_internal[3]);
    // carry_internal[5] assigned above

    // For bits 5-8
    assign carry_internal[6] = G[5] | (P[5] & carry_internal[5]);
    assign carry_internal[7] = G[6] | (P[6] & carry_internal[6]);
    assign carry_internal[8] = G[7] | (P[7] & carry_internal[7]);
    // carry_internal[9] assigned above

    // For bits 9-12
    assign carry_internal[10] = G[9]  | (P[9]  & carry_internal[9]);
    assign carry_internal[11] = G[10] | (P[10] & carry_internal[10]);
    assign carry_internal[12] = G[11] | (P[11] & carry_internal[11]);
    // carry_internal[13] assigned above

    // For bits 13-16
    assign carry_internal[14] = G[13] | (P[13] & carry_internal[13]);
    assign carry_internal[15] = G[14] | (P[14] & carry_internal[14]);
    assign carry_internal[16] = G[15] | (P[15] & carry_internal[15]);
    assign carry_internal[17] = G[16] | (P[16] & carry_internal[16]); // final carry out = Cout

    assign S = P ^ carry_internal[16:1]; // sum bits: S[i] = P[i] ^ carry_internal[i]

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