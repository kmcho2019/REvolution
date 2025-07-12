module cla_8bit(
    input  [7:0] A,
    input  [7:0] B,
    input        Cin,
    output [7:0] S,
    output       Cout,
    output       G_out,  // Block generate
    output       P_out   // Block propagate
);
    wire [7:0] P = A ^ B;
    wire [7:0] G = A & B;
    wire [8:0] C;

    assign C[0] = Cin;
    // Compute carries using carry-lookahead equations
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G[3] | (P[3] & C[3]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & C[5]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G[7] | (P[7] & C[7]);

    assign S = P ^ C[7:0];
    assign Cout = C[8];

    // Block propagate and generate for this 8-bit block
    assign P_out = &P;                 // Propagate if all bits propagate
    assign G_out = G[7] | (P[7] & G[6]) | (P[7]&P[6]&G[5]) | (P[7]&P[6]&P[5]&G[4])
                 | (P[7]&P[6]&P[5]&P[4]&G[3]) | (P[7]&P[6]&P[5]&P[4]&P[3]&G[2])
                 | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&G[1])
                 | (P[7]&P[6]&P[5]&P[4]&P[3]&P[2]&P[1]&G[0]);
endmodule

module cla_4bit(
    input  [3:0] G,
    input  [3:0] P,
    input        Cin,
    output [3:1] C,
    output       Cout
);
    // Compute carries C[1] to C[3] and Cout using CLA equations
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) 
               | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
endmodule

module adder_32bit(
    input  [32:1] A,
    input  [32:1] B,
    output [32:1] S,
    output        C32
);
    // Split inputs into four 8-bit blocks (bits [1:8], [9:16], [17:24], [25:32])
    wire [7:0] A0 = A[8:1];
    wire [7:0] A1 = A[16:9];
    wire [7:0] A2 = A[24:17];
    wire [7:0] A3 = A[32:25];

    wire [7:0] B0 = B[8:1];
    wire [7:0] B1 = B[16:9];
    wire [7:0] B2 = B[24:17];
    wire [7:0] B3 = B[32:25];

    wire [3:0] G_block;
    wire [3:0] P_block;
    wire [3:1] C_block;
    wire c0 = 1'b0;

    wire cout0, cout1, cout2, cout3;

    wire [7:0] S0, S1, S2, S3;

    // Instantiate 8-bit CLA blocks
    cla_8bit cla0(.A(A0), .B(B0), .Cin(c0), .S(S0), .Cout(cout0), .G_out(G_block[0]), .P_out(P_block[0]));
    cla_8bit cla1(.A(A1), .B(B1), .Cin(C_block[1]), .S(S1), .Cout(cout1), .G_out(G_block[1]), .P_out(P_block[1]));
    cla_8bit cla2(.A(A2), .B(B2), .Cin(C_block[2]), .S(S2), .Cout(cout2), .G_out(G_block[2]), .P_out(P_block[2]));
    cla_8bit cla3(.A(A3), .B(B3), .Cin(C_block[3]), .S(S3), .Cout(cout3), .G_out(G_block[3]), .P_out(P_block[3]));

    // Instantiate 4-bit CLA to find carries for upper blocks
    cla_4bit cla_top(.G(G_block), .P(P_block), .Cin(c0), .C(C_block), .Cout(C32));

    // Assemble sum output
    assign S[8:1]   = S0;
    assign S[16:9]  = S1;
    assign S[24:17] = S2;
    assign S[32:25] = S3;
endmodule