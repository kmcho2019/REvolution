module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Pg,
    output Gg
);
    wire [3:0] G = A & B;
    wire [3:0] P = A ^ B;
    wire [3:0] C;
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    
    assign Pg = &P;
    assign Gg = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign S = P ^ C;
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
    
    // Compute both possible carry scenarios
    cla_4bit low0 (.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .S(S0[3:0]), .Pg(), .Gg());
    cla_4bit low1 (.A(A[3:0]), .B(B[3:0]), .Cin(1'b1), .S(S1[3:0]), .Pg(), .Gg());
    
    cla_4bit high0 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b0), .S(S0[7:4]), .Pg(Pg0), .Gg(Gg0));
    cla_4bit high1 (.A(A[7:4]), .B(B[7:4]), .Cin(1'b1), .S(S1[7:4]), .Pg(Pg1), .Gg(Gg1));
    
    // Select results based on actual carry-in
    assign S = Cin ? S1 : S0;
    assign Cout = Cin ? (Gg1 | (Pg1 & 1'b1)) : (Gg0 | (Pg0 & 1'b0));
endmodule

module adder_32bit (
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);
    wire [2:0] carry;
    wire Pg0, Gg0, Pg1, Gg1;
    
    // First 4-bit CLA block (LSB)
    cla_4bit block0 (.A(A[4:1]), .B(B[4:1]), .Cin(1'b0), .S(S[4:1]), .Pg(Pg0), .Gg(Gg0));
    
    // Middle 8-bit carry-select blocks
    csel_8bit block1 (.A(A[12:5]), .B(B[12:5]), .Cin(Gg0 | (Pg0 & 1'b0)), .S(S[12:5]), .Cout(carry[0]));
    csel_8bit block2 (.A(A[20:13]), .B(B[20:13]), .Cin(carry[0]), .S(S[20:13]), .Cout(carry[1]));
    
    // MSB 16-bit CLA block
    cla_4bit block3a (.A(A[24:21]), .B(B[24:21]), .Cin(carry[1]), .S(S[24:21]), .Pg(Pg1), .Gg(Gg1));
    cla_4bit block3b (.A(A[28:25]), .B(B[28:25]), .Cin(Gg1 | (Pg1 & carry[1])), .S(S[28:25]), .Pg(Pg2), .Gg(Gg2));
    cla_4bit block3c (.A(A[32:29]), .B(B[32:29]), .Cin(Gg2 | (Pg2 & (Gg1 | (Pg1 & carry[1]))), .S(S[32:29]), .Pg(), .Gg(Gg3));
    
    assign C32 = Gg3 | (Pg2 & (Gg2 | (Pg1 & (Gg1 | (Pg0 & carry[1]))));
endmodule