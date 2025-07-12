module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Compute ~B for two's complement subtraction
    wire [63:0] B_neg = ~B;

    // Slice A and ~B into 16-bit chunks
    wire [15:0] A0 = A[15:0];
    wire [15:0] A1 = A[31:16];
    wire [15:0] A2 = A[47:32];
    wire [15:0] A3 = A[63:48];

    wire [15:0] B0 = B_neg[15:0];
    wire [15:0] B1 = B_neg[31:16];
    wire [15:0] B2 = B_neg[47:32];
    wire [15:0] B3 = B_neg[63:48];

    // Internal wires for sums
    wire [15:0] R0, R1, R2, R3;

    // Block generate and propagate signals for each 16-bit block
    wire G0, P0;
    wire G1, P1;
    wire G2, P2;
    wire G3, P3;

    // Carry signals between 16-bit blocks (4 carries for 4 blocks)
    wire [4:0] C16;

    assign C16[0] = 1'b1; // Initial carry-in for two's complement subtraction (+1)

    // 16-bit CLA blocks with block generate/propagate outputs
    cla_16bit_blk u_cla0(.A(A0), .B(B0), .cin(C16[0]), .sum(R0), .G(G0), .P(P0));
    cla_16bit_blk u_cla1(.A(A1), .B(B1), .cin(C16[1]), .sum(R1), .G(G1), .P(P1));
    cla_16bit_blk u_cla2(.A(A2), .B(B2), .cin(C16[2]), .sum(R2), .G(G2), .P(P2));
    cla_16bit_blk u_cla3(.A(A3), .B(B3), .cin(C16[3]), .sum(R3), .G(G3), .P(P3));

    // 4-bit CLA carry lookahead to compute carries between 16-bit blocks
    cla_4bit_carry_lookahead u_cla_carry16 (
        .G({G3,G2,G1,G0}),
        .P({P3,P2,P1,P0}),
        .cin(C16[0]),
        .cout(C16[4]),
        .Cout(C16[3:1])
    );

    assign result = {R3, R2, R1, R0};

    // Overflow detection logic remains same
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule


// 16-bit CLA block built from four 4-bit CLA blocks
// Outputs sum[15:0], block generate G and propagate P signals
module cla_16bit_blk (
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire        cin,
    output wire [15:0] sum,
    output wire        G,
    output wire        P
);
    wire [3:0] G4, P4;      // Generate and propagate per 4-bit block
    wire [4:0] C4;          // Carry signals between 4-bit blocks

    // Initial carry-in
    assign C4[0] = cin;

    // Four 4-bit CLA blocks
    cla_4bit_blk u_blk0 (.A(A[3:0]),   .B(B[3:0]),   .cin(C4[0]), .sum(sum[3:0]),   .G(G4[0]), .P(P4[0]));
    cla_4bit_blk u_blk1 (.A(A[7:4]),   .B(B[7:4]),   .cin(C4[1]), .sum(sum[7:4]),   .G(G4[1]), .P(P4[1]));
    cla_4bit_blk u_blk2 (.A(A[11:8]),  .B(B[11:8]),  .cin(C4[2]), .sum(sum[11:8]),  .G(G4[2]), .P(P4[2]));
    cla_4bit_blk u_blk3 (.A(A[15:12]), .B(B[15:12]), .cin(C4[3]), .sum(sum[15:12]), .G(G4[3]), .P(P4[3]));

    // 4-bit carry lookahead to generate carry signals for 4-bit blocks
    cla_4bit_carry_lookahead u_carry (
        .G(G4),
        .P(P4),
        .cin(C4[0]),
        .cout(C4[4]),
        .Cout(C4[3:1])
    );

    // Block generate and propagate for 16-bit block:
    // G = G3 + P3*G2 + P3*P2*G1 + P3*P2*P1*G0
    // P = P3 & P2 & P1 & P0
    assign G = G4[3] | (P4[3] & G4[2]) | (P4[3] & P4[2] & G4[1]) | (P4[3] & P4[2] & P4[1] & G4[0]);
    assign P = P4[3] & P4[2] & P4[1] & P4[0];

endmodule


// 4-bit CLA block: sum = A + B + cin, outputs sum[3:0], generate G and propagate P signals
module cla_4bit_blk (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       G,
    output wire       P
);
    wire [3:0] P_i = A ^ B;
    wire [3:0] G_i = A & B;
    wire [4:0] C;

    assign C[0] = cin;

    // Carry lookahead equations
    assign C[1] = G_i[0] | (P_i[0] & C[0]);
    assign C[2] = G_i[1] | (P_i[1] & G_i[0]) | (P_i[1] & P_i[0] & C[0]);
    assign C[3] = G_i[2] | (P_i[2] & G_i[1]) | (P_i[2] & P_i[1] & G_i[0]) | (P_i[2] & P_i[1] & P_i[0] & C[0]);
    assign C[4] = G_i[3] | (P_i[3] & G_i[2]) | (P_i[3] & P_i[2] & G_i[1]) | (P_i[3] & P_i[2] & P_i[1] & G_i[0]) | (P_i[3] & P_i[2] & P_i[1] & P_i[0] & C[0]);

    assign sum = P_i ^ C[3:0];

    // Block generate and propagate
    assign G = G_i[3] | (P_i[3] & G_i[2]) | (P_i[3] & P_i[2] & G_i[1]) | (P_i[3] & P_i[2] & P_i[1] & G_i[0]);
    assign P = &P_i; // P0 & P1 & P2 & P3

endmodule


// 4-bit CLA carry lookahead block for carry signals among blocks
// Inputs: G[3:0], P[3:0], initial carry in (cin)
// Outputs: cout (final carry out), Cout[3:1] intermediate carry outs
module cla_4bit_carry_lookahead (
    input  wire [3:0] G,
    input  wire [3:0] P,
    input  wire       cin,
    output wire       cout,
    output wire [2:0] Cout
);
    // Compute carries C1, C2, C3, and cout
    // Carry equations:
    // C1 = G0 + P0 * cin
    // C2 = G1 + P1 * G0 + P1 * P0 * cin
    // C3 = G2 + P2 * G1 + P2 * P1 * G0 + P2 * P1 * P0 * cin
    // cout = G3 + P3 * G2 + P3 * P2 * G1 + P3 * P2 * P1 * G0 + P3 * P2 * P1 * P0 * cin

    wire c1, c2, c3;

    assign c1 = G[0] | (P[0] & cin);
    assign c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
    assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);

    assign Cout = {c3, c2, c1};
endmodule