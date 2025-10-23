module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);
    
    assign S = P ^ C;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [7:0] carry;
    
    // Direct chain of 8x 4-bit CLA blocks
    cla_4bit cla0 (.A(A[4:1]),   .B(B[4:1]),   .Cin(1'b0),    .S(S[4:1]),   .Cout(carry[0]));
    cla_4bit cla1 (.A(A[8:5]),   .B(B[8:5]),   .Cin(carry[0]), .S(S[8:5]),   .Cout(carry[1]));
    cla_4bit cla2 (.A(A[12:9]),  .B(B[12:9]),  .Cin(carry[1]), .S(S[12:9]),  .Cout(carry[2]));
    cla_4bit cla3 (.A(A[16:13]), .B(B[16:13]), .Cin(carry[2]), .S(S[16:13]), .Cout(carry[3]));
    cla_4bit cla4 (.A(A[20:17]), .B(B[20:17]), .Cin(carry[3]), .S(S[20:17]), .Cout(carry[4]));
    cla_4bit cla5 (.A(A[24:21]), .B(B[24:21]), .Cin(carry[4]), .S(S[24:21]), .Cout(carry[5]));
    cla_4bit cla6 (.A(A[28:25]), .B(B[28:25]), .Cin(carry[5]), .S(S[28:25]), .Cout(carry[6]));
    cla_4bit cla7 (.A(A[32:29]), .B(B[32:29]), .Cin(carry[6]), .S(S[32:29]), .Cout(carry[7]));
    
    assign C32 = carry[7];
endmodule