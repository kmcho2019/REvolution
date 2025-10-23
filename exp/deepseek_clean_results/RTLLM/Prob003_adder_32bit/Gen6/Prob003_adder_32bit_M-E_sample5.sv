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

module cla_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [1:0] carry;
    
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(carry[0]));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry[0]), .S(S[7:4]), .Cout(carry[1]));
    
    assign Cout = carry[1];
endmodule

module carry_select_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] S0, S1;
    wire Cout0, Cout1;
    
    // Compute both possible cases
    cla_8bit add0 (.A(A), .B(B), .Cin(1'b0), .S(S0), .Cout(Cout0));
    cla_8bit add1 (.A(A), .B(B), .Cin(1'b1), .S(S1), .Cout(Cout1));
    
    // Select correct result
    assign S = Cin ? S1 : S0;
    assign Cout = Cin ? Cout1 : Cout0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [5:0] carry;
    
    // Hybrid architecture: 4-8-4-8-4-4 blocks
    cla_4bit  block0 (.A(A[4:1]),  .B(B[4:1]),  .Cin(1'b0),    .S(S[4:1]),  .Cout(carry[0]));
    cla_8bit  block1 (.A(A[12:5]), .B(B[12:5]), .Cin(carry[0]), .S(S[12:5]), .Cout(carry[1]));
    cla_4bit  block2 (.A(A[16:13]),.B(B[16:13]),.Cin(carry[1]), .S(S[16:13]),.Cout(carry[2]));
    carry_select_8bit block3 (.A(A[24:17]),.B(B[24:17]),.Cin(carry[2]), .S(S[24:17]),.Cout(carry[3]));
    cla_4bit  block4 (.A(A[28:25]),.B(B[28:25]),.Cin(carry[3]), .S(S[28:25]),.Cout(carry[4]));
    cla_4bit  block5 (.A(A[32:29]),.B(B[32:29]),.Cin(carry[4]), .S(S[32:29]),.Cout(carry[5]));
    
    assign C32 = carry[5];
endmodule