module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout,
    output       Pout,
    output       Gout
);
    wire [3:0] G = A & B;     // Generate signals
    wire [3:0] P = A ^ B;     // Propagate signals

    // Carry signals
    wire c1, c2, c3;

    assign c1 = G[0] | (P[0] & Cin);
    assign c2 = G[1] | (P[1] & c1);
    assign c3 = G[2] | (P[2] & c2);
    assign Cout = G[3] | (P[3] & c3);

    assign S = P ^ {c3, c2, c1, Cin};

    // Group propagate and generate
    assign Pout = &P;                         // P0 & P1 & P2 & P3
    assign Gout = G[3] | (P[3] & G[2]) | (P[3]&P[2]&G[1]) | (P[3]&P[2]&P[1]&G[0]);
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0] c;         // internal carries between 4-bit blocks
    wire [3:0] P;         // group propagate for each 4-bit block
    wire [3:0] G;         // group generate for each 4-bit block

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (
        .A(A[3:0]),
        .B(B[3:0]),
        .Cin(Cin),
        .S(S[3:0]),
        .Cout(c[0]),
        .Pout(P[0]),
        .Gout(G[0])
    );

    cla_4bit cla1 (
        .A(A[7:4]),
        .B(B[7:4]),
        .Cin(c[0]),
        .S(S[7:4]),
        .Cout(c[1]),
        .Pout(P[1]),
        .Gout(G[1])
    );

    cla_4bit cla2 (
        .A(A[11:8]),
        .B(B[11:8]),
        .Cin(c[1]),
        .S(S[11:8]),
        .Cout(c[2]),
        .Pout(P[2]),
        .Gout(G[2])
    );

    cla_4bit cla3 (
        .A(A[15:12]),
        .B(B[15:12]),
        .Cin(c[2]),
        .S(S[15:12]),
        .Cout(c[3]),
        .Pout(P[3]),
        .Gout(G[3])
    );

    // Compute internal carries between 4-bit blocks using group propagate and generate
    // Carry-in for cla1: c[0]
    // c[0] already assigned from cla0.Cout

    // For demonstration, let's verify correctness using CLA equations on block carries:
    // c[0] = G[0] + P[0]*Cin (already cla0.Cout)
    // c[1] = G[1] + P[1]*c[0]
    // c[2] = G[2] + P[2]*c[1]
    // c[3] = G[3] + P[3]*c[2]

    // To ensure correctness and in case internal carries are not strictly from cla outputs, recompute
    wire c0_calc, c1_calc, c2_calc, c3_calc;
    assign c0_calc = G[0] | (P[0] & Cin);
    assign c1_calc = G[1] | (P[1] & c0_calc);
    assign c2_calc = G[2] | (P[2] & c1_calc);
    assign c3_calc = G[3] | (P[3] & c2_calc);

    // Override carries c with calculated ones for internal consistency
    // This also guarantees Cout correct
    // For sum calculation, since sum depends on carries from 4-bit blocks, these internal carries must match

    // But since each cla_4bit block outputs Cout using the same logic, it is consistent. So no override needed for sum.

    assign Cout = c3_calc;
endmodule

module adder_32bit(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] S,
    output        C32
);
    wire C16;

    cla_16bit cla_lower (
        .A(A[15:0]),
        .B(B[15:0]),
        .Cin(1'b0),
        .S(S[15:0]),
        .Cout(C16)
    );

    cla_16bit cla_upper (
        .A(A[31:16]),
        .B(B[31:16]),
        .Cin(C16),
        .S(S[31:16]),
        .Cout(C32)
    );
endmodule