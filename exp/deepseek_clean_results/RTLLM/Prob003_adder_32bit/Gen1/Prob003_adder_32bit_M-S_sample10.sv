module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] P, G;
    wire [8:0] C;
    
    assign P = A ^ B;
    assign G = A & B;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & C[0]);
    assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C[0]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & C[4]);
    assign C[7] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & C[4]);
    assign C[8] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & C[4]);
    
    assign S = P ^ C[7:0];
    assign Cout = C[8];
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [4:0] carry;
    
    assign carry[0] = 1'b0; // Initial carry-in
    
    cla_8bit cla0 (.A(A[8:1]), .B(B[8:1]), .Cin(carry[0]), .S(S[8:1]), .Cout(carry[1]));
    cla_8bit cla1 (.A(A[16:9]), .B(B[16:9]), .Cin(carry[1]), .S(S[16:9]), .Cout(carry[2]));
    cla_8bit cla2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry[2]), .S(S[24:17]), .Cout(carry[3]));
    cla_8bit cla3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry[3]), .S(S[32:25]), .Cout(C32));
endmodule