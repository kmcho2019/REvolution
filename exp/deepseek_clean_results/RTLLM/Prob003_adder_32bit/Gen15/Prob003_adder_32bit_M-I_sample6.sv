module cla_4bit_enhanced (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output G_group,
    output P_group
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    assign S = P ^ C;
    assign G_group = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign P_group = P[3] & P[2] & P[1] & P[0];
endmodule

module adder_32bit_optimized (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] G_group;
    wire [7:0] P_group;
    wire [7:0] carry;
    
    // First-level CLA blocks
    cla_4bit_enhanced cla0 (.A(A[4:1]),   .B(B[4:1]),   .Cin(1'b0),     .S(S[4:1]),   .G_group(G_group[0]), .P_group(P_group[0]));
    cla_4bit_enhanced cla1 (.A(A[8:5]),   .B(B[8:5]),   .Cin(carry[0]), .S(S[8:5]),   .G_group(G_group[1]), .P_group(P_group[1]));
    cla_4bit_enhanced cla2 (.A(A[12:9]),  .B(B[12:9]),  .Cin(carry[1]), .S(S[12:9]),  .G_group(G_group[2]), .P_group(P_group[2]));
    cla_4bit_enhanced cla3 (.A(A[16:13]), .B(B[16:13]), .Cin(carry[2]), .S(S[16:13]), .G_group(G_group[3]), .P_group(P_group[3]));
    cla_4bit_enhanced cla4 (.A(A[20:17]), .B(B[20:17]), .Cin(carry[3]), .S(S[20:17]), .G_group(G_group[4]), .P_group(P_group[4]));
    cla_4bit_enhanced cla5 (.A(A[24:21]), .B(B[24:21]), .Cin(carry[4]), .S(S[24:21]), .G_group(G_group[5]), .P_group(P_group[5]));
    cla_4bit_enhanced cla6 (.A(A[28:25]), .B(B[28:25]), .Cin(carry[5]), .S(S[28:25]), .G_group(G_group[6]), .P_group(P_group[6]));
    cla_4bit_enhanced cla7 (.A(A[32:29]), .B(B[32:29]), .Cin(carry[6]), .S(S[32:29]), .G_group(G_group[7]), .P_group(P_group[7]));
    
    // Second-level carry lookahead
    assign carry[0] = G_group[0] | (P_group[0] & 1'b0);
    assign carry[1] = G_group[1] | (P_group[1] & carry[0]);
    assign carry[2] = G_group[2] | (P_group[2] & carry[1]);
    assign carry[3] = G_group[3] | (P_group[3] & carry[2]);
    assign carry[4] = G_group[4] | (P_group[4] & carry[3]);
    assign carry[5] = G_group[5] | (P_group[5] & carry[4]);
    assign carry[6] = G_group[6] | (P_group[6] & carry[5]);
    assign carry[7] = G_group[7] | (P_group[7] & carry[6]);
    
    assign C32 = carry[7];
endmodule