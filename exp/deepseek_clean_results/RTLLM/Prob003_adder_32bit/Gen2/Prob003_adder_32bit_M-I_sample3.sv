module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    // Generate and Propagate
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    
    // Carry computation using Kogge-Stone parallel prefix
    wire [7:0] C;
    wire [7:0] G1, P1;
    wire [7:0] G2, P2;
    
    // First level
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    assign G1[2] = G[2] | (P[2] & G[1]);
    assign P1[2] = P[2] & P[1];
    assign G1[3] = G[3] | (P[3] & G[2]);
    assign P1[3] = P[3] & P[2];
    assign G1[4] = G[4] | (P[4] & G[3]);
    assign P1[4] = P[4] & P[3];
    assign G1[5] = G[5] | (P[5] & G[4]);
    assign P1[5] = P[5] & P[4];
    assign G1[6] = G[6] | (P[6] & G[5]);
    assign P1[6] = P[6] & P[5];
    assign G1[7] = G[7] | (P[7] & G[6]);
    assign P1[7] = P[7] & P[6];
    
    // Second level
    assign G2[0] = G1[0];
    assign P2[0] = P1[0];
    assign G2[1] = G1[1];
    assign P2[1] = P1[1];
    assign G2[2] = G1[2] | (P1[2] & G1[0]);
    assign P2[2] = P1[2] & P1[0];
    assign G2[3] = G1[3] | (P1[3] & G1[1]);
    assign P2[3] = P1[3] & P1[1];
    assign G2[4] = G1[4] | (P1[4] & G1[2]);
    assign P2[4] = P1[4] & P1[2];
    assign G2[5] = G1[5] | (P1[5] & G1[3]);
    assign P2[5] = P1[5] & P1[3];
    assign G2[6] = G1[6] | (P1[6] & G1[4]);
    assign P2[6] = P1[6] & P1[4];
    assign G2[7] = G1[7] | (P1[7] & G1[5]);
    assign P2[7] = P1[7] & P1[5];
    
    // Final carries
    assign C[0] = Cin;
    assign C[1] = G1[0] | (P1[0] & Cin);
    assign C[2] = G2[2] | (P2[2] & Cin);
    assign C[3] = G2[3] | (P2[3] & Cin);
    assign C[4] = G2[4] | (P2[4] & Cin);
    assign C[5] = G2[5] | (P2[5] & Cin);
    assign C[6] = G2[6] | (P2[6] & Cin);
    assign C[7] = G2[7] | (P2[7] & Cin);
    assign Cout = C[7];
    
    // Sum
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C8, C16, C24;
    
    cla_8bit block0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout(C8));
    cla_8bit block1 (.A(A[16:9]), .B(B[16:9]), .Cin(C8), .S(S[16:9]), .Cout(C16));
    cla_8bit block2 (.A(A[24:17]), .B(B[24:17]), .Cin(C16), .S(S[24:17]), .Cout(C24));
    cla_8bit block3 (.A(A[32:25]), .B(B[32:25]), .Cin(C24), .S(S[32:25]), .Cout(C32));
endmodule