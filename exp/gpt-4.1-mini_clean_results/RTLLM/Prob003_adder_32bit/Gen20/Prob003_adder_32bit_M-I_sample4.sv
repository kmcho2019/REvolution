module cla_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] S,
    output       G,  // Group generate
    output       P   // Group propagate
);
    wire [3:0] P_i = A ^ B;     // propagate per bit
    wire [3:0] G_i = A & B;     // generate per bit
    wire [4:0] C;

    assign C[0] = Cin;
    // Carry lookahead logic for 4 bits
    assign C[1] = G_i[0] | (P_i[0] & C[0]);
    assign C[2] = G_i[1] | (P_i[1] & C[1]);
    assign C[3] = G_i[2] | (P_i[2] & C[2]);
    assign C[4] = G_i[3] | (P_i[3] & C[3]);

    assign S = P_i ^ C[3:0];
    // Group generate and propagate for this 4-bit block
    assign G = G_i[3] | (P_i[3] & G_i[2]) | (P_i[3] & P_i[2] & G_i[1]) | (P_i[3] & P_i[2] & P_i[1] & G_i[0]);
    assign P = &P_i; // all propagates ANDed
endmodule

module cla_16bit(
    input  [15:0] A,
    input  [15:0] B,
    input         Cin,
    output [15:0] S,
    output        Cout
);
    wire [3:0] G_block, P_block; // group generate/propagate for 4-bit blocks
    wire [4:0] C; // carries at block boundaries and bits within block

    assign C[0] = Cin;

    // Instantiate four 4-bit CLA blocks
    cla_4bit cla0 (.A(A[3:0]),   .B(B[3:0]),   .Cin(C[0]), .S(S[3:0]),   .G(G_block[0]), .P(P_block[0]));
    cla_4bit cla1 (.A(A[7:4]),   .B(B[7:4]),   .Cin(C[1]), .S(S[7:4]),   .G(G_block[1]), .P(P_block[1]));
    cla_4bit cla2 (.A(A[11:8]),  .B(B[11:8]),  .Cin(C[2]), .S(S[11:8]),  .G(G_block[2]), .P(P_block[2]));
    cla_4bit cla3 (.A(A[15:12]), .B(B[15:12]), .Cin(C[3]), .S(S[15:12]), .G(G_block[3]), .P(P_block[3]));

    // Calculate carry into each 4-bit block using CLA logic for blocks
    assign C[1] = G_block[0] | (P_block[0] & C[0]);
    assign C[2] = G_block[1] | (P_block[1] & C[1]);
    assign C[3] = G_block[2] | (P_block[2] & C[2]);
    assign C[4] = G_block[3] | (P_block[3] & C[3]);

    assign Cout = C[4];
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    wire c16;
    cla_16bit cla_lower (
        .A(A[16:1]),
        .B(B[16:1]),
        .Cin(1'b0),
        .S(S[16:1]),
        .Cout(c16)
    );

    cla_16bit cla_upper (
        .A(A[32:17]),
        .B(B[32:17]),
        .Cin(c16),
        .S(S[32:17]),
        .Cout(C32)
    );
endmodule