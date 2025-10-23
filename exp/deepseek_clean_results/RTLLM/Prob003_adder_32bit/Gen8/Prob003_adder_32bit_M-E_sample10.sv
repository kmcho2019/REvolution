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
    wire carry_mid;
    
    cla_4bit cla0 (.A(A[3:0]), .B(B[3:0]), .Cin(Cin), .S(S[3:0]), .Cout(carry_mid));
    cla_4bit cla1 (.A(A[7:4]), .B(B[7:4]), .Cin(carry_mid), .S(S[7:4]), .Cout(Cout));
endmodule

module csel_8bit (
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
);
    wire [7:0] S0, S1;
    wire Cout0, Cout1;
    
    // Compute both possible versions
    cla_8bit block0 (.A(A), .B(B), .Cin(1'b0), .S(S0), .Cout(Cout0));
    cla_8bit block1 (.A(A), .B(B), .Cin(1'b1), .S(S1), .Cout(Cout1));
    
    // Select correct version based on actual carry-in
    assign S = Cin ? S1 : S0;
    assign Cout = Cin ? Cout1 : Cout0;
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [3:0] carry;
    
    // First block is regular CLA since no previous carry exists
    cla_8bit block0 (.A(A[8:1]), .B(B[8:1]), .Cin(1'b0), .S(S[8:1]), .Cout(carry[0]));
    
    // Subsequent blocks use carry-select
    csel_8bit block1 (.A(A[16:9]), .B(B[16:9]), .Cin(carry[0]), .S(S[16:9]), .Cout(carry[1]));
    csel_8bit block2 (.A(A[24:17]), .B(B[24:17]), .Cin(carry[1]), .S(S[24:17]), .Cout(carry[2]));
    csel_8bit block3 (.A(A[32:25]), .B(B[32:25]), .Cin(carry[2]), .S(S[32:25]), .Cout(carry[3]));
    
    assign C32 = carry[3];
endmodule