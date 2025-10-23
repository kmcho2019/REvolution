module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] G = A & B;
    wire [7:0] P = A ^ B;
    wire [7:0] C;
    
    // Brent-Kung parallel prefix carry computation
    wire [3:0] G1, P1;
    wire [1:0] G2, P2;
    wire G3, P3;
    
    // First level
    assign G1[0] = G[0] | (P[0] & Cin);
    assign P1[0] = P[0];
    assign G1[1] = G[1] | (P[1] & G[0]);
    assign P1[1] = P[1] & P[0];
    assign G1[2] = G[2] | (P[2] & G[1]);
    assign P1[2] = P[2] & P[1];
    assign G1[3] = G[3] | (P[3] & G[2]);
    assign P1[3] = P[3] & P[2];
    
    // Second level
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign P2[0] = P1[1] & P1[0];
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign P2[1] = P1[3] & P1[2];
    
    // Third level
    assign G3 = G2[1] | (P2[1] & G2[0]);
    assign P3 = P2[1] & P2[0];
    
    // Carry computation
    assign C[0] = Cin;
    assign C[1] = G1[0];
    assign C[2] = G2[0];
    assign C[3] = G1[2] | (P1[2] & G2[0]);
    assign C[4] = G3;
    assign C[5] = G1[4] | (P[4] & C[4]);
    assign C[6] = G1[5] | (P[5] & C[5]);
    assign C[7] = G1[6] | (P[6] & C[6]);
    assign Cout = G[7] | (P[7] & C[7]);
    
    // Sum computation
    assign S = P ^ C;
endmodule

module cla_16bit (
    input [15:0] A,
    input [15:0] B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire C8;
    
    cla_8bit cla0 (.A(A[7:0]), .B(B[7:0]), .Cin(Cin), .S(S[7:0]), .Cout(C8));
    cla_8bit cla1 (.A(A[15:8]), .B(B[15:8]), .Cin(C8), .S(S[15:8]), .Cout(Cout));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire C16;
    
    cla_16bit low (.A(A[16:1]), .B(B[16:1]), .Cin(1'b0), .S(S[16:1]), .Cout(C16));
    cla_16bit high (.A(A[32:17]), .B(B[32:17]), .Cin(C16), .S(S[32:17]), .Cout(C32));
endmodule