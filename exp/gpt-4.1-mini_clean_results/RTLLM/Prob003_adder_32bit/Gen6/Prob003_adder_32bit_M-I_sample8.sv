module cla_16bit(
    input  [16:1] A,
    input  [16:1] B,
    input         Cin,
    output [16:1] S,
    output        Cout
);
    wire [16:1] G; // Generate signals for each bit
    wire [16:1] P; // Propagate signals for each bit
    wire [4:0] CG; // Group generate
    wire [4:0] CP; // Group propagate
    wire [16:0] C; // Carry signals

    // Bitwise generate and propagate
    assign G = A & B;
    assign P = A ^ B;

    // Group generate and propagate for 4-bit groups
    // Group 1: bits 1 to 4
    assign CG[1] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]);
    assign CP[1] = P[4] & P[3] & P[2] & P[1];
    // Group 2: bits 5 to 8
    assign CG[2] = G[8] | (P[8] & G[7]) | (P[8] & P[7] & G[6]) | (P[8] & P[7] & P[6] & G[5]);
    assign CP[2] = P[8] & P[7] & P[6] & P[5];
    // Group 3: bits 9 to 12
    assign CG[3] = G[12] | (P[12] & G[11]) | (P[12] & P[11] & G[10]) | (P[12] & P[11] & P[10] & G[9]);
    assign CP[3] = P[12] & P[11] & P[10] & P[9];
    // Group 4: bits 13 to 16
    assign CG[4] = G[16] | (P[16] & G[15]) | (P[16] & P[15] & G[14]) | (P[16] & P[15] & P[14] & G[13]);
    assign CP[4] = P[16] & P[15] & P[14] & P[13];

    // Carry-in for each group
    assign C[0] = Cin;
    assign C[4] = CG[1] | (CP[1] & C[0]);
    assign C[8] = CG[2] | (CP[2] & C[4]);
    assign C[12] = CG[3] | (CP[3] & C[8]);
    assign C[16] = CG[4] | (CP[4] & C[12]);

    // Compute carries for each bit within the 4-bit groups
    // Group 1: bits 1 to 4
    assign C[1] = G[1] | (P[1] & C[0]);
    assign C[2] = G[2] | (P[2] & C[1]);
    assign C[3] = G[3] | (P[3] & C[2]);
    // C[4] is already assigned (group carry)

    // Group 2: bits 5 to 8
    assign C[5] = G[5] | (P[5] & C[4]);
    assign C[6] = G[6] | (P[6] & C[5]);
    assign C[7] = G[7] | (P[7] & C[6]);
    // C[8] is already assigned

    // Group 3: bits 9 to 12
    assign C[9] = G[9] | (P[9] & C[8]);
    assign C[10] = G[10] | (P[10] & C[9]);
    assign C[11] = G[11] | (P[11] & C[10]);
    // C[12] is already assigned

    // Group 4: bits 13 to 16
    assign C[13] = G[13] | (P[13] & C[12]);
    assign C[14] = G[14] | (P[14] & C[13]);
    assign C[15] = G[15] | (P[15] & C[14]);
    // C[16] is already assigned

    // Sum calculation
    assign S = P ^ C[15:0];

    assign Cout = C[16];
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