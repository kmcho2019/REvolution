module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [15:0] P = A ^ B;        // Propagate signals
    wire [15:0] G = A & B;        // Generate signals

    // Group propagate and generate for each 4-bit block
    wire [3:0] P_group;
    wire [3:0] G_group;

    assign P_group[0] = &P[3:0];
    assign P_group[1] = &P[7:4];
    assign P_group[2] = &P[11:8];
    assign P_group[3] = &P[15:12];

    assign G_group[0] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign G_group[1] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]);
    assign G_group[2] = G[11] | (P[11] & G[10]) | (P[11] & P[10] & G[9]) | (P[11] & P[10] & P[9] & G[8]);
    assign G_group[3] = G[15] | (P[15] & G[14]) | (P[15] & P[14] & G[13]) | (P[15] & P[14] & P[13] & G[12]);

    // Carry-in for each 4-bit block
    wire [4:0] C;
    assign C[0] = Cin;
    assign C[1] = G_group[0] | (P_group[0] & C[0]);
    assign C[2] = G_group[1] | (P_group[1] & C[1]);
    assign C[3] = G_group[2] | (P_group[2] & C[2]);
    assign C[4] = G_group[3] | (P_group[3] & C[3]);

    // Compute individual bit carries within each 4-bit block
    wire [15:1] carry;

    // Block 0 (bits 0 to 3)
    assign carry[1] = G[0] | (P[0] & C[0]);
    assign carry[2] = G[1] | (P[1] & carry[1]);
    assign carry[3] = G[2] | (P[2] & carry[2]);

    // Block 1 (bits 4 to 7)
    assign carry[5] = G[4] | (P[4] & C[1]);
    assign carry[6] = G[5] | (P[5] & carry[5]);
    assign carry[7] = G[6] | (P[6] & carry[6]);

    // Block 2 (bits 8 to 11)
    assign carry[9]  = G[8]  | (P[8]  & C[2]);
    assign carry[10] = G[9]  | (P[9]  & carry[9]);
    assign carry[11] = G[10] | (P[10] & carry[10]);

    // Block 3 (bits 12 to 15)
    assign carry[13] = G[12] | (P[12] & C[3]);
    assign carry[14] = G[13] | (P[13] & carry[13]);
    assign carry[15] = G[14] | (P[14] & carry[14]);

    // Final sum and carry out
    assign S[0]  = P[0]  ^ C[0];
    assign S[1]  = P[1]  ^ carry[1];
    assign S[2]  = P[2]  ^ carry[2];
    assign S[3]  = P[3]  ^ carry[3];
    assign S[4]  = P[4]  ^ C[1];
    assign S[5]  = P[5]  ^ carry[5];
    assign S[6]  = P[6]  ^ carry[6];
    assign S[7]  = P[7]  ^ carry[7];
    assign S[8]  = P[8]  ^ C[2];
    assign S[9]  = P[9]  ^ carry[9];
    assign S[10] = P[10] ^ carry[10];
    assign S[11] = P[11] ^ carry[11];
    assign S[12] = P[12] ^ C[3];
    assign S[13] = P[13] ^ carry[13];
    assign S[14] = P[14] ^ carry[14];
    assign S[15] = P[15] ^ carry[15];

    assign Cout = C[4];
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