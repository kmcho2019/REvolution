module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       Cout,
    output       Gp,   // Group propagate
    output       Gg    // Group generate
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [4:0] C;

    assign C[0] = Cin;
    // Carry lookahead logic for 4 bits
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) |
                  (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign S = P ^ C[3:0];
    assign Cout = C[4];

    // Group propagate and generate for this 4-bit block
    assign Gp = &P; // All propagate bits ANDed
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    // Four 4-bit CLA blocks
    wire [3:0] S0, S1, S2, S3;
    wire C1, C2, C3;

    wire Gp0, Gg0, Gp1, Gg1, Gp2, Gg2, Gp3, Gg3;

    // Instantiate 4-bit CLAs
    cla_4bit cla0 (.A(A[3:0]),    .B(B[3:0]),    .Cin(Cin),  .S(S0), .Cout(),  .Gp(Gp0), .Gg(Gg0));
    cla_4bit cla1 (.A(A[7:4]),    .B(B[7:4]),    .Cin(),    .S(S1), .Cout(),  .Gp(Gp1), .Gg(Gg1));
    cla_4bit cla2 (.A(A[11:8]),   .B(B[11:8]),   .Cin(),    .S(S2), .Cout(),  .Gp(Gp2), .Gg(Gg2));
    cla_4bit cla3 (.A(A[15:12]),  .B(B[15:12]),  .Cin(),    .S(S3), .Cout(),  .Gp(Gp3), .Gg(Gg3));

    // Compute carries at 4-bit group boundaries using CLA logic
    wire C0 = Cin;
    wire C_1, C_2, C_3, C_4;

    assign C_1 = Gg0 | (Gp0 & C0);
    assign C_2 = Gg1 | (Gp1 & Gg0) | (Gp1 & Gp0 & C0);
    assign C_3 = Gg2 | (Gp2 & Gg1) | (Gp2 & Gp1 & Gg0) | (Gp2 & Gp1 & Gp0 & C0);
    assign C_4 = Gg3 | (Gp3 & Gg2) | (Gp3 & Gp2 & Gg1) | (Gp3 & Gp2 & Gp1 & Gg0) |
                 (Gp3 & Gp2 & Gp1 & Gp0 & C0);

    // Connect Cin for the 4-bit blocks beyond the first
    // cla0.Cin = Cin (already assigned)
    // cla1.Cin = C_1
    // cla2.Cin = C_2
    // cla3.Cin = C_3

    // For proper connection, we need to reinstantiate cla_4bit with Cin inputs connected
    // Thus instantiate the 4-bit CLAs with proper Cin signals:
    cla_4bit cla0_inst (.A(A[3:0]),    .B(B[3:0]),    .Cin(Cin),  .S(S0), .Cout(),  .Gp(), .Gg());
    cla_4bit cla1_inst (.A(A[7:4]),    .B(B[7:4]),    .Cin(C_1),  .S(S1), .Cout(),  .Gp(), .Gg());
    cla_4bit cla2_inst (.A(A[11:8]),   .B(B[11:8]),   .Cin(C_2),  .S(S2), .Cout(),  .Gp(), .Gg());
    cla_4bit cla3_inst (.A(A[15:12]),  .B(B[15:12]),  .Cin(C_3),  .S(S3), .Cout(),  .Gp(), .Gg());

    // Assign final outputs
    assign S = {S3, S2, S1, S0};
    assign Cout = C_4;
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