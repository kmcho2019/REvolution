module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    // Generate and Propagate signals
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    
    // Carry computation using Brent-Kung parallel prefix
    wire [7:0] C;
    wire [3:0] G1, P1;
    wire [1:0] G2, P2;
    wire G3, P3;
    
    // First level (4-bit groups)
    assign G1[0] = G[0] | (P[0] & Cin);
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    assign G1[2] = G[2] | (P[2] & G[1]);
    assign P1[2] = P[2] & P[1];
    assign G1[3] = G[3] | (P[3] & G[2]);
    assign P1[3] = P[3] & P[2];
    
    // Second level (2-bit groups)
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign P2[0] = P1[1] & P1[0];
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign P2[1] = P1[3] & P1[2];
    
    // Third level (final carry)
    assign G3 = G2[1] | (P2[1] & G2[0]);
    assign P3 = P2[1] & P2[0];
    
    // Generate all carries
    assign C[0] = Cin;
    assign C[1] = G1[0] | (P1[0] & Cin);
    assign C[2] = G2[0] | (P2[0] & Cin);
    assign C[3] = G1[2] | (P1[2] & C[2]);
    assign C[4] = G3 | (P3 & Cin);
    assign C[5] = G1[4] | (P1[4] & C[4]);
    assign C[6] = G2[2] | (P2[2] & C[4]);
    assign C[7] = G1[6] | (P1[6] & C[6]);
    assign Cout = G3 | (P3 & Cin);
    
    // Sum computation
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    cla_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout(carry[0]));
    cla_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(carry[0]), .S(S[16:9]), .Cout(carry[1]));
    cla_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry[1]), .S(S[24:17]), .Cout(carry[2]));
    cla_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry[2]), .S(S[32:25]), .Cout(carry[3]));
    
    assign C32 = carry[3];
endmodule